Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711976;
	b=z1W58XOItpinVAx24HLi7hx+LaU+KSGQGPGVggY9gdQTtt+aWhN4iPCXAiyqeFksiLID
	 wLgoThyVuASrSFlPP3GovaZ5oWFba+4iDipTCKWL2Kdh1zhaNGQGoZ3DHR5/hfz7StxSM
	 JMdOz04UNzKEBt4qy8qB8fAElveP8sewiSxXa9SS+Hh3wDknxFG1bl9YCiZdNlSifHUlL
	 IuINTcUyFtT37oUowH3T7PSpjFWuevyLlT/WqSdp8hsbbIRYsy2jrpubfxjZXJQXUArK/
	 IfSjaEq7XRM/cvhHnq9+1x13owErilLFAoIKObfHA0Rd+YlGZhqHq4SJW47OOP5gJ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711976;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5qH9uU2RYKh6XIToRZvT3ow0waxxSB8wLXqXQtdP32c=;
	b=Uk32eB2w6OAzCPqgLkS5gASEtA1btXlX30RhgUyiHHxUfEuD6StVpdz5OPTuMwgbSysa
	 ChkUTpQrAsICVhAXJ1DITyCpdjgA48emdLeU05WMh81JYqjZLx0RjgKLnYzegvNZptb3H
	 9soW+U7LpGuuEzO2/0h71K1OR6RI0IWnqMQtmdwEzE3uznsLMfmX/I+3OyCCOVxXbw0fz
	 zaCy7fOtPd08Pj11eLl83WiIqtTjepJB6PWP3pbMxdd2Mn52ERkTlHhwEB2O+LxvlaIep
	 gYpIp8aNhOu37E+KOpVD7FbrWjgAPV8Q1PNk1iBXXfgGD9Bj1zqcTIH+LuI3iCMWWow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxU5PQGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34109606A31C;
	Thu, 26 Nov 2026 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxU5PQGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466201F000C0;
	Thu, 26 Nov 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795711975;
	bh=5qH9uU2RYKh6XIToRZvT3ow0waxxSB8wLXqXQtdP32c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SxU5PQGoh3FdeXUb/zZe+iY3rUcOMRcRxSrtlOzk3paXo5yOTqHQW5yzSvByJq1ZU
	 R3b/pZXT/KfX1G0MgF9rcJHgXd3VgeGvkRcW3q+pfjDYiSVSEjTx81Yb/F7xrNWuNV
	 V40BUSLVgfXFOF31TjrqEHmyoeyV0tKowB46vgcmOdi3m6lZb1de3p8R0/stmVBDRV
	 7iEisOk65fU5CBPT9VBRqAZLQdk56bInhx82nvKOoGWqDaznlfE3+NAWI8XmS8KVWK
	 S5XnMDWsjd2IuEiilCummtaNrv1wEaQ+3B0O+M/ehMe9hIWTDYTwBKbPN93Rvubpzv
	 6FeF79qzrReJw==
Date: Thu, 26 Nov 2026 16:52:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, oupton@kernel.org, 
	fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	rkeilty@meta.com, atish.patra@linux.dev, dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <awhij_-9OARRRi9D@gremlin>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <86wlpzycnn.wl-maz@kernel.org>
 <563d2406-dcfe-43b6-8f21-2a7694f1f266@linux.dev>
 <86v75jy48c.wl-maz@kernel.org>
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
In-Reply-To: <86v75jy48c.wl-maz@kernel.org>

On Thu, Nov 26, 2026 at 03:58:11PM +0000, Marc Zyngier wrote:
> On Thu, 26 Nov 2026 14:32:04 +0000,
> Usama Arif <usama.arif@linux.dev> wrote:
>
> [nonsense deleted]
>
> > > Now, to the patch itself: I see no reason to special-case this. If
> > > kvm_mmu_cache_min_pages() is an indication of what is needed, then
> > > this macro should be driven by it, or the whole allocator take it into
> > > account. And then you adjust it by whatever fudge factor seems
> > > appropriate.
> > >
> >
> > Completely agree! [1] does that: no page-size special case, and
> > a capacity of KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL for every
> > page size.  It can't track kvm_mmu_cache_min_pages()
> > at runtime: the vCPU's cache is shared by the canonical and NV shadow
> > MMUs, and its capacity must stay fixed. So it has to cover the largest
> > minimum, which stage-2 caps at 3, and 4 is that plus one page of fudge.
>
> Of course it can. That's not exactly rock science to add, rather than
> relying on another set of bad heuristics. And this must cover more
> than a single mapping per top-up, because that has a ripple effect on
> the speed at which we can split large blocks (funnily enough, people
> care about that stuff).

Hmm is splitting a factor here re: the cache?

In kvm_mmu_split_huge_pages() it is using kvm->arch.mmu.split_page_cache which
is a separate cache altogether right?

And splitting on fault is via e.g. kvm_vm_mem_abort() -> user_mem_abort() which
tops up anyway? (Minus an NV case which is a bug I think, I can send that as a
patch separately? I mention in another reply.)

Maybe I missed a case?

Re: the speed, having bigger cache size doesn't speed anything up as the refill
refills to the max each time, so you're doing the same # of allocations, just
maybe with a much bigger latency on one fault (seems bad to me)?


>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.
>

--
Cheers, Lorenzo
