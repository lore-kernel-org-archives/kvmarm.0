Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E63B5CB9
	for <kvmarm@lists.linux.dev>; Sat,  2 Sep 2023 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ykAU0IuBWCOAh/V+bHoSxJwmB/ONT4m36dnHXVeI+gc=; b=M/kbn/GSgML7w28FfggmH7XG6B
	AoIOPSIS/rWN+MsWq75QfC/Aee19klAuIvycRMJdm8AER52SmM8ldLrimDyFfGzgfA1Lh27sJMhjx
	9yR6IcYoIrGndMgjYzvRoVm4M/ZCmqT4UI5tCYhmnQUr66neucxUcFUTIXtw2EMPmynRUEf96gTef
	F7fCCcZU2Z6YpiIZfwoADbPIrShS3D2YGkNno4Vrc5chfgi8c+J1r/XUDm2LU5pVzVck07858xIDd
	e7YyQUXHRVLmmrJ2hEWQiN04YMXTLjuPogl7tDhN6y4GH1ZZAKxIH2VC7FBmAjAZduDxoiuRKz6Xp
	RntoFSfw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qcR9o-00EvUv-Kx; Sat, 02 Sep 2023 13:59:24 +0000
Date: Sat, 2 Sep 2023 14:59:24 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: seanjc@google.com, ackerleytng@google.com, akpm@linux-foundation.org,
	anup@brainfault.org, aou@eecs.berkeley.edu,
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org,
	david@redhat.com, isaku.yamahata@gmail.com, jarkko@kernel.org,
	jmorris@namei.org, kirill.shutemov@linux.intel.com,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, liam.merwick@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-riscv@lists.infradead.org,
	linux-security-module@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mail@maciej.szmigiero.name,
	maz@kernel.org, michael.roth@amd.com, mpe@ellerman.id.au,
	oliver.upton@linux.dev, palmer@dabbelt.com,
	paul.walmsley@sifive.com, paul@paul-moore.com, pbonzini@redhat.com,
	qperret@google.com, serge@hallyn.com, tabba@google.com,
	vannapurve@google.com, wei.w.wang@intel.com,
	yu.c.zhang@linux.intel.com
Subject: Re: [PATCH gmem FIXUP] mm, compaction: make testing
 mapping_unmovable() safe
Message-ID: <ZPM/vJnwI4bi9bo2@casper.infradead.org>
References: <20230901082025.20548-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901082025.20548-2-vbabka@suse.cz>

On Fri, Sep 01, 2023 at 10:20:26AM +0200, Vlastimil Babka wrote:
> As Kirill pointed out, mapping can be removed under us due to
> truncation. Test it under folio lock as already done for the async
> compaction / dirty folio case. To prevent locking every folio with
> mapping to do the test, do it only for unevictable folios, as we can
> expect the unmovable mapping folios are also unevictable - it is the
> case for guest memfd folios.
> 
> Also incorporate comment update suggested by Matthew.

In the meantime, 866ff80176aa went upstream earlier this merge window,
so it's going to have some conflicts.

