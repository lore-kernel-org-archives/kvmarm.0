Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795533952;
	b=XxZ2MEM1E1ViOHdlGYWzB0qV8Tef3T1oo/ZIDXn3LRik4lD+HuElmiqCmiJSXF1a447Y
	 gCk1FYSg8oAm9Zqf2COuJ+cFRAA7PuIMMgwMOySvzadqwhuRg66R+EcXH73juAlC7bUS9
	 m/qkqni1d9XyO5PVd28zr8V5ej/iX4N9zr2nsHa09HzHt+PZlhrSQ7laqkInclI5GZ0jE
	 VmGUFJDCSWYGTrMKkPyTT3g/Y5WCeQTbLS0JvoLhYb9PdGHdprxJY1fkv5JTrYfc2iYg+
	 K3+sUfd07RZc3vbrZbrmFZf59Pof9B3pTBPIkahX/mXy/NV3/wwsFq62JzUKLfi8CDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=1UXh4PQJOR3VknqTlOD7G3LYkfB1ZlA2WQOnvCIXzSk=;
	b=kLq1/+WG4TYcO/uA8IAkGtuy+mV7QZF8nxiKSioWgR+s/CN1rhvTLizJWLtUENrVeb7U
	 R/4ryCp1D+jUh1SiDuK/uzKhiwBdgnW8iMPZpn3Z0fnhdgT+GEI1U2Fo6ecWeL6E7fAUd
	 9Mk+97y0WzT9uSFTAb2SbI4gYs+SkiW5+mLsjGDx77jFi4cJjMiuWE6NUxrRw0hQA0VZ/
	 b7jlWap/BBhip40tN7HhOLD5OoCgDBfo7sXuZ5XWy9pff8bIOFZXc+T1KagCr5CbDy/qa
	 yQ9QJu9J8ytckSEepFfEECgR+NwocNrnp7gt+u/uG0mtN0gaZz7DXHOAWuPBvjFnBCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZKayue7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C7D606A32D;
	Tue, 24 Nov 2026 15:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZKayue7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CC31F000C6;
	Tue, 24 Nov 2026 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795533952;
	bh=1UXh4PQJOR3VknqTlOD7G3LYkfB1ZlA2WQOnvCIXzSk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BZKayue7T+OsylZjV79b6R0ytIW756sZrlscpck2YyZhapT9Gi9uxQD2TAqTTjgK1
	 Ny12Sm0RAzgn+HtgnA1nCyeqansp2lHh7ivIj/Ix1qFbH4HuVOa8qCEjIyvtoi9D6R
	 +jHmiVlbd0ZMEtoLUPptwix0CB+DWa1XVAy1+YYY895ci0d7bJUu/p9MbsNhjGaGh1
	 rfdPKCuFn+l+eN4jST+wJuMHZLweG6N0w74drNJ6WDvCm0j+qp/odn0AgQomKQb69w
	 XBI0ZPyD+v+OEE7bdKKZ7xDxe6TzGo/x9t8gCGRgnlp50DOQffqNVxBveg3UN2VOyB
	 +YF0ajNdmMBkw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Matlack" <dmatlack@google.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Tarun Sahu"
 <tarunsahu@google.com>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Mike Rapoport" <rppt@kernel.org>,  <robin.murphy@arm.com>,
  <maz@kernel.org>,  <will@kernel.org>,  "Alexander Graf"
 <graf@amazon.com>,  <seanjc@google.com>,  <jgg@nvidia.com>,
  <loganodell@google.com>,  <arnd@arndb.de>,  <dwmw2@infradead.org>,
  <baolu.lu@linux.intel.com>,  "Bjorn Helgaas" <bhelgaas@google.com>,
  <oupton@kernel.org>,  <alex@shazbot.org>,  <gle.com@google.com>,
  <pbonzini@redhat.com>,  "Andrew Morton" <akpm@linux-foundation.org>,
  <kevin.tian@intel.com>,  <joro@8bytes.org>,  <kvmarm@lists.linux.dev>,
  <linux-pci@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <kvm@vger.kernel.org>,  <iommu@lists.linux.dev>,
  <linux-arm-kernel@lists.infradead.org>,  <skhawaja@google.com>,
  <sagis@google.com>,  <linux-arch@vger.kernel.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
In-Reply-To: <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com> (David Matlack's message
	of "Mon, 23 Nov 2026 09:32:17 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-6-tarunsahu@google.com>
	<2vxzse0rzjdn.fsf@kernel.org> <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
Date: Tue, 24 Nov 2026 15:25:44 +0000
Message-ID: <2vxz33sqz1xj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Nov 23 2026, David Matlack wrote:

> On Mon Nov 23, 2026 at 6:56 AM PST, Pratyush Yadav wrote:
> [...]
>
>> When we have all this available, I don't see the point in
>> differentiating between optional and required features at the ABI level.
>> At the ABI level, all that matters is what the incoming kernel
>> understands. If the incoming kernel does not understand a specific
>> field, the outgoing kernel should just not use it. There's no point.
>> Best case, it gets ignored.
>
> I pretty strongly disagree.
>
> An optional feature is one that the next kernel does not need to
> understand to correctly restore the object. A required feature is one
> that the next kernel must understand to correctly restore the object.
> Optional features can be enabled without any compatibility concerns.
> Required features must be enabled carefully (IMO via uAPI) to avoid
> breaking Live Update.
>
> I agree it's a good idea for the outgoing kernel to check that the next
> kernel supports all of the required features it is using, so the Live
> Update can be stopped before the kexec. But that doesn't remove the
> need for the distinction. The next kernel still has to decide what to
> do when it sees a feature bit it doesn't understand, e.g. because no
> spec was provided, the spec was wrong, or we kexec'd into a different
> kernel than planned. Without the distinction it can only:
>
>  A. Treat all features as optional, which risks misinterpreting state
>     and corrupting memory if the previous kernel did not properly
>     validate the next kernel's capabilities.

Right, that's a bad idea.

>
>  B. Treat all features as required, which means no new feature can be
>     enabled until every kernel it might Live Update to (including
>     rollback targets) understands it, even when those kernels could
>     safely ignore it.

I think this is what we should do.

Why do all kernels need to understand a new feature?

If a kernel can safely parse an object without ever looking at an
optional feature, why set it in the first place? The outgoing kernel
already knows its target can't understand it.

So say you add a new optional feature in kernel X+1. For a rollback, the
kernel X+1 knows it is going to X which doesn't understand the feature.
It should just not use it in the payload, which means it never activates
the bit for that feature. All the feature bits X sees are the ones it
understand, and everything goes smoothly.

And to be clear, I'm saying that the feature bits in the ABI header
should be set dynamically based on what is used in the payload. The
feature bits in the spec are static. They say what the target kernel
understands. The feature bits in the payload are dynamic. They say what
features are actually used.

>
> Neither of those is a good outcome.
>
>> The semantics of required or optional then become "can I describe this
>> object with the capabilities I can use?". If the answer is yes,
>> serialization succeeds, if the answer is no, serialization fails. So
>> with this, KHO_MAP_F_MULTI_INDEX or KHO_MAP_F_DYN_DEPTH are indeed
>> optional. All memfds can be described without these, they just will be
>> less efficient.
>
> I think this is a different meaning of "optional". Whether the outgoing
> kernel can choose not to use a feature is a decision for the serializer.
> Whether the next kernel can safely ignore a feature's data is a property
> of the ABI. KHO_MAP_F_MULTI_INDEX is optional in the first sense, but
> required in the second: a kernel that doesn't understand it will
> misinterpret the map. The header needs to convey the second.

Right, which is why a payload handed to an old kernel should never set
KHO_MAP_F_MULTI_INDEX. Even if you have a property that is truly
optional and ignoring it will still make things work fine, why would you
want to set it in the first place? You know it will be ignored, so just
don't use it.

>
> So I see the spec and required bits as complementary: the spec lets the
> outgoing kernel avoid features the next kernel doesn't support and fail
> before kexec, and required bits let the next kernel fail safely if that
> check was skipped or wrong.

I see a marginal benefit in setting the optional bits by adding a tiny
bit more safety. But even then, it only hides the real problem. The
previous kernel should not be skipping its checks in the first place. If
you're lucky, it might only end up using an optional feature and you
might be able to ignore it. But if the checks don't happen or are
broken, you'd be just as likely to be unlucky and the previous kernel
might use a required feature if it skips the spec checks.

I don't think it buys us any functionality. It just hides the problem in
some lucky cases.

In fact, we could even add a "strict" mode in the future, where the
outgoing kernel refuses KHO if the spec to the incoming kernel is not
provided.

-- 
Regards,
Pratyush Yadav
