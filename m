Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0C4433024;
	Tue, 11 Aug 2026 10:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786444328; cv=none; b=oeHaVZbgPl5n3XqcJsRwcQuqTuE7LIESw4VeWBINPeQ48QWoLJQcvYUbDyBOf3G5vN/ljz7Ndkjqs0ltxOJBHGbDii12fOpQ2aEJPVQZsr8L8VfGyyrDysT5MsnBFrIA3felsc/8zzytygB8i7RBSv5RCEjCrFzdX2YU5nKjy8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786444328; c=relaxed/simple;
	bh=gStdq8IVQqJ0gwSpuGR4KyjP8u00daUPac7gXFqnwdA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UAX2mDXZQb5RJ/ziqSBShYPs5hq1kM4ETgEu/BH+jRfjm6yLosIcl8H5XekCdOe8GGgi2xJIkkiTy7DrdDeikp4A3oYew7uiDi+Ks3pXmI8aWAU2yZyFIB6NhdyvrTBtdApqeGHyp9Gd56OzTHh1Ca3aOlyjQkP6m37fpzBN0mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkssVT/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkssVT/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E6B1F00A3A;
	Tue, 11 Aug 2026 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786444326;
	bh=6kqp/Jib2qHuKnuXjTW7DmBQCS/40A0zxBCp5T9KsPM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QkssVT/ZEngrzN04DrcXhMOGvp2/M5W0FwI70XNEh6QmviL80rjbG/xm8Z8DY/veP
	 4/5hlZB68qF+W0qhrPBu5QDHdz3LEebs5hqxgz2tSMDSR18UIxm6/2431u8q7I28du
	 4aEWTQIDWhF2GnpPLVvUbA14iMQp0K+2zHB07Zks59uo8rVarUwQQa6ooozIlDHYvA
	 Z3mRlx13lH0cw3mBOSJ0fVwwSye7D9hO8Ae9MJcZvPI7XmEu1ahiNwljhCI63aDXFd
	 ZJDHJ+g49/1tM/69n2VTE+I2MMdqysmC6BCKSzET2ZAzZuovCQj6yokstS57mwsjHh
	 nB/WQuPbeVmGA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>,  fuad.tabba@linux.dev,  Andrew Morton
 <akpm@linux-foundation.org>,  seanjc@google.com,  dmatlack@google.com,
  Shuah Khan <skhan@linuxfoundation.org>,  Jonathan Corbet
 <corbet@lwn.net>,  david@redhat.com,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 06/11] KVM: guest_memfd: Move internal definitions to
 internal header
In-Reply-To: <CAEvNRgEVxQS2r0_iPHciV=NEKFzwnrfitp-QdP1keAg5Ud7-TQ@mail.gmail.com>
	(Ackerley Tng's message of "Thu, 30 Jul 2026 11:12:54 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-7-tarunsahu@google.com>
	<CAEvNRgEVxQS2r0_iPHciV=NEKFzwnrfitp-QdP1keAg5Ud7-TQ@mail.gmail.com>
Date: Tue, 11 Aug 2026 12:31:59 +0200
Message-ID: <2vxztsp13q3k.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jul 30 2026, Ackerley Tng wrote:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Extract 'struct gmem_file', 'struct gmem_inode', and GMEM_I() from
>> virt/kvm/guest_memfd.c into a new internal header virt/kvm/guest_memfd.h.
>> Also split __kvm_gmem_create() to expose a non-static
>> __kvm_gmem_create_file() helper that returns a 'struct file *' instead of
>> an fd.
>>
>
> This is done basically to support a new virt/kvm/guest_memfd_luo.c
> file.

My $0.02 on this: I think it is useful to split out the live update code
into a separate file. It makes for easier reviews, and puts a clear
boundary between core and live update. We have done it for memfd/shmem
for example (see mm/memfd_luo.c) and for other live update series in
flight like PCI or IOMMU.

>
> Would like to know what Sean thinks of this! I'd like to know for future
> guest_memfd work too.
>
>> These internal definitions and helpers allow upcoming guest_memfd Live
>> Update Orchestrator (LUO) preservation code to access guest_memfd
>> internals and reconstruct guest_memfd file instances from preserved state
>> without installing them into a file descriptor table up front.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
[...]

-- 
Regards,
Pratyush Yadav
