Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837786;
	b=vDhyqoqmZ2Z13oMBASRENtAdC7wxKGmrIJdXUGJSaTG1kwUfM6tXcmlSU0DdiyeIN3Mi
	 RcPbJg1XMJEWfoCWtWgGMBhuvQUE0CIrofZXSKiU1imaHFQe5sMPr5nIJLNXW3lKtM/vb
	 PkhtnTUuVJCFcwbjzfWshKVJd3DFSRador5y+5/tLkcswYaF6JyyHMrEvpm6pFQes/mtP
	 wB7VnfjMoE5Q7ulnWdBDkuYNDTT/fWEGbgBbMRb9JwGkmzfvYfi7fx1n58g10QS0855dI
	 tthpaqt/cL8Qma1WFRj2dVnfhNBVHdBWeU0ar2QJ9a2IvNdx5ucPSCV0AL71dlvD1mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837786;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
	b=Jm9O1//b66SethBkugV5aFQdDHgUsWE81FCiVYgw1EfweMT11Nt5TbTVG1Oo38+ItKEj
	 I0HDihXopwUaox0WaKdeT2EcyFNVRsOx9ZEGSBSjiKA67ajX3Ny1dQdfj+EXJ8NPLx25a
	 GlowmnVKIWiTmNNwzsxaKCA7EGw5W7ImBIXzHLlFMRAZB/rOLWYwywiY7bGAYH61BmCdp
	 SDkBXytsNZX3LAqvbfrryaxQmvO/A0HTEc2mmVURomhnLcWzk5vxoLigqJHDUiYHICUde
	 3Nam9TyudvO5VEJi/7tbEOjb1ZbMHowrDxh21+pBztJy6Nc43+rvW8dfIRUddzEbTdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=D2UELt21;
	arc=none smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BC4606A883
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 14:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80BC4606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=D2UELt21
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-67db23d8892so1451383d50.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 06:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794837784; x=1795442584; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
        b=D2UELt21I5ILCf8AXZAEuvMOfdZHdngeN2nZtUV2REtiuku1ygCCWC6sVC3onou0Br
         oQgvOxRZoTp8D+NGU7iMNdRkGD4GMudxuOM/qxLAN4HNvJCIqEjV8HCQ2tkEVxb8WMIn
         zUVhOr2skKLmaXE2OTvAnaAOV+JYUASTo8JnfRIvZajeR5h5yR1NdJ0hVlJETdKPkeWs
         PnweAQuMZJlxO1Lnh93SDU6l7IMrJvOymCajsQnP3W1vR6mFbkdvoVyTaARMsLcD+qRe
         eXwOcTOOJcfy7OR8PE+10MxMUYK2z1syHo+Xc5Wmz1EjSA3zd2lR40x0KfD/5kCYGCVd
         AxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794837784; x=1795442584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
        b=h+K7+7W7cZz0MAcuABibRL+ywB+fsbEFaT3BVFxccbijnONMH7YZd773KBTcW5AMn8
         hzHrTGpd5A41Gafrkm4Uf6sfls+4F09h2zj2xb7ydBu10lR+YAm5ALi4J44t9wAuPHOn
         xes7hAPShewsnTqxx4g5vWwQHvF7FoGmfg/YEPU7xpcJB4Qf0j2vLOJqBKIR/3zMdSpU
         rL5pizKOMs4gGBHr6hONUfK8uwYbqbgNH0yTRjSOkgXNjpI7mJd44GMH8EZb9NnjwDrr
         ta5Gy4AoiCHsBSEprjKTG/2/BHtCX0i4RR+FDTStjogAYpJB8B1CjSICoHDf0RMLhHuh
         acLQ==
X-Forwarded-Encrypted: i=1; AL+hErHdUs2a/8IqzIHdNU36hg1lJihaLltLCk19AJ0nYaZhCXE7wShQUQXZPmDfpnKkatdjrXOtc7Q=@lists.linux.dev
X-Gm-Message-State: APuU4Z+vGBS/3perK/RLdY6D3Ya8PJmpX4rhxELhpkEHpbj+XbjXFTCQ
	kOo58luKgZufkI28tPcvmI0IBNK+hk4FFFT80vh7WeJ5GEUpCvKesJlW7kivx/99xfY=
X-Gm-Gg: AZFdTZeuRyPZp6ZJN81jH9399D+1w+Q2lWBUaI1Ogoh9WziAhgsXzJWdKZY6W5FpYbH
	DMZa2dzd09spnGJAmiUiNUGVin2tF/MDZVxXisXZ4fP3cwTmy1unJRi6lav0Oxt0Ux4TZeQCY/Q
	Y+kB1ub/cLKKUfsqsE6tjsxPpUUzEOqSYZQm5i8dqOXw2s+5vuUgM/GZy4+ywUX4SLaR7BDw/EQ
	cacj++EKhAjXQpWDXbekJ98w/8cCDfoAodbibZxIh+w23bM1VcBO4iSsZX+uWZtNKCu2ss0ew7C
	KYfjLBi/x8EDJlyJ0w06P1o92cbPB6eP51wI2Ec85ERpK+6fEACpL2aMXcSOXFEqhyCyOheViUx
	s9Ih3ljvt4IXWt/Lm359Sum8G61PQcYRJWqc7VOfXoAidffzHxosPt3/sdAALqjZekP5+kv6Zz/
	A6f7wnrehBODvZSVeclHQPk/aU+rE4SFytSClmOqGjnBJ5m4smdsE90MD9leIPkVmh4/Q11Q7el
	pr9wL7p82GimzxxGpE0bofBcY30px8Iy1YfQIKHogWzg0lNqISGySooSIKfWQodkRUxgnUve6Yo
	AaLd/S/03xTZKcLq1jU5ds//dbY=
X-Received: by 2002:a53:ccc7:0:b0:67b:f935:8639 with SMTP id 956f58d0204a3-67d89787ecdmr4996887d50.63.1794837784278;
        Mon, 16 Nov 2026 06:03:04 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8b889csm858426085a.32.2026.11.16.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 06:03:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSxIR-00000009Q2N-0sq0;
	Mon, 16 Nov 2026 10:02:59 -0400
Date: Mon, 16 Nov 2026 10:02:59 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory
 transitions
Message-ID: <20261116140259.GL2532299@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org>
 <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
 <yq5ah5hgyj1p.fsf@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ah5hgyj1p.fsf@kernel.org>

On Mon, Nov 16, 2026 at 07:28:42PM +0530, Aneesh Kumar K.V wrote:
> Fuad Tabba <fuad.tabba@linux.dev> writes:
> 
> > Hi Aneesh,
> >
> > On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
> > <aneesh.kumar@kernel.org> wrote:
> > [...]
> >> Keep allocations on platforms without memory encryption on the ordinary page
> >> allocator path so the original GFP constraints, including __GFP_ZERO, remain
> >> intact. Remove post-transition memset() calls that are now redundant and
> >> explicitly clear allocations on paths where no transition occurs.
> >>
> >> This intentionally makes every private-to-shared transition destructive;
> >> callers can no longer use set_memory_decrypted() to preserve existing contents.
> >
> > pKVM shares memory in place, and a guest has to be able to share
> > memory it has already set up, as Vincent pointed out [1]. That was one
> > of the primary reasons for in-place conversion in guest_memfd.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/
> 
> 
> Thanks for catching this. We discussed it before, but I reached the
> opposite conclusion:
> 
> https://lore.kernel.org/all/yq5a5wzw2ree.fsf@kernel.org
> 
> My mistake. How do you suggest we handle this? We want to avoid zeroing
> pages multiple times with different CoCo configurations. For example, to
> allocate a zeroed page, we currently do:
> 
> alloc_pages(__GFP_ZERO)
> set_memory_decrypted()
> memset(0, PAGE_SIZE)

Just like you are wrapping set_memory_decrypted() in an allocator API
the user that wants to have the no-change sharing needs its own
special API too.

Then you can bury a special implementation for pkvm there.

Where is this special user in the kernel anyhow?

Jason
