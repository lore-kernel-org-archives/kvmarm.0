Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BB43793D0
	for <kvmarm@lists.linux.dev>; Sat,  5 Sep 2026 23:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788652150; cv=none; b=cj8HTiyS6vIISMcsUHdg8lz8WdGmYVWSaNJuU5SeOiUb2TLa+eEEnvu1fH8+ntnL2T1SOpjMRugkeOvL7DlgDnhtWEEsD+PMPI5CEKON7m7+GQewgX77qOLo2E/uG9gYePcmxwzxuY4E3r1RfkiS+OJe3o5IDPjeKg7VM/VHKz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788652150; c=relaxed/simple;
	bh=78ZaUHpCCmF9Q0SRtDPZW3k16driAdZe8cBTHH9U4Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ugNc9Lj4oKulQn/eAJSLcwdJE3OeSEUEUcd7xtchgV+LL/3fKXpZXltLUmjZVwbuQySrZ+GPIu3LDXiw+podvkSJV2HJkW0MoJ6YxqnR7gxNmwALe/ZNEpRTpzNZUgBy90G7PTaJHM9PXcoh1LHrf6CKOjrZj/LvPmhzk1qq+BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uWYZ/mVM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uWYZ/mVM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 285D31477;
	Sat,  5 Sep 2026 16:48:56 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 810673F673;
	Sat,  5 Sep 2026 16:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788652139; bh=78ZaUHpCCmF9Q0SRtDPZW3k16driAdZe8cBTHH9U4Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uWYZ/mVMj/RrfQNI2EgFHEj2UqFhaoPkrXi/X8bsDBUV203Qu3dn/kF8JwPQ6obOz
	 88mI97vEqyEZkbdgT7uK1cMCgMc4ZgVs+OshFnQ4vyC4qsyMOqwP1tTxge9BJG7NnQ
	 1pOtrQGvsC7KD/eOoAwm31GjAMc2V965Mwqt/TE8=
Date: Sun, 6 Sep 2026 00:48:49 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>, Marc Zyngier <maz@kernel.org>
Cc: Wang Han <wanghan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	oupton@kernel.org, tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, ljs@kernel.org, 
	itaru.kitayama@fujitsu.com
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
Message-ID: <rytvo6a7sulfb2no2fclvtpggk4ekqzs6n6xkqlffldbzua4lz@rnskx6qj2cxy>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260902163500.1841671-1-wanghan@linux.alibaba.com>
 <877bl26aqg.wl-maz@kernel.org>
 <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
 <875x0l5udh.wl-maz@kernel.org>
 <eylfcgxs2xzu57czyuhkpmum45lpxyccyu2yh3mipr67aq3xo6@xinygxzavoja>
 <2bde734c-eb86-4c7a-958d-b431e6d13671@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bde734c-eb86-4c7a-958d-b431e6d13671@linux.alibaba.com>

On Sat, Sep 05, 2026 at 11:49:32PM +0800, Shuai Xue wrote:

[...]

> 
> Hi Wei-Lin,
> 
> Your PARange analysis is what this whole diagnosis rests on -- the
> 48-bit/256x arithmetic is exactly right, and our ftrace data confirms
> it to the chunk: every full-IPA kvm_nested_s2_unmap() in our traces
> walks precisely 262,144 1GB chunks, the number from your table. The
> kvm_ipa_limit=40 experiment also pointed straight at the answer. I'd
> only push back on the last sentence:
> 
> > 
> > With this, I think there aren't other underlying issues, it just is that
> > slow unfortunately..
> 
> 
> I don't think it is "just that slow" -- I think it is a specific
> regression, and your own data localizes it better than the conclusion
> suggests.
> 
> The thing is, kvm_ipa_limit=40 cannot tell *what* each chunk spends
> its ~3.3us on, because the walk is also per-chunk: cutting the chunk
> count by 256x shrinks both terms together, whichever one dominates.
> The experiment that separates them is one where the chunk count does
> not change at all.
> 
> We ran that experiment. Details are in my reply to Marc, but the
> short version:
> 
>   - Before: 877ms per callback, 262,144 chunk calls, 262,144
>     broadcasts. Chunk count and broadcast count are exactly equal
>     (8,476,033 = 8,476,033 over the trace window) -- every chunk
>     ends in a broadcast, mapped or not. Per chunk, ~4.6us of the
>     ~5.1us is inside kvm_tlb_flush_vmid_range(); the walk of an
>     empty chunk is ~0.2us. In an uncontended numad episode, 87% of
>     the 1312ms is flush time and 8% is walk time.
> 
>   - After conditioning the flush on the walk having actually cleared
>     a valid leaf (the candidate fix in my other mail): same 262,144
>     chunks, same walk, ~110ms instrumented. Nothing about the walk
>     changed -- ~3.1us of the per-chunk 3.3us was the broadcast.
> 
>   - And the table really is empty, as Marc says: with the flush
>     count acting as a detector, the first full-IPA unmap of the boot
>     issues 2 flushes (the EL1-boot-period mappings, a few dozen
>     pages in two 1GB chunks); all 35 subsequent ones issue zero.
> 
> The code history agrees. Before 7657ea920c54, the TLBI lived inside
> stage2_put_pte()'s 'if (kvm_pte_valid(ctx->old))' -- an empty walk
> issued zero invalidations, ever. v6.6 hoisted the invalidation out
> to the end of kvm_pgtable_stage2_unmap() to batch it into one range
> TLBI per call, but the condition got dropped on the way. So "since
> v6.6, the cost is proportional to the IPA range, not to the number
> of mappings" -- which is precisely why the empty table pays in full,
> and why I'd frame it as a fixable regression rather than an inherent
> cost.
> 
> None of this subtracts from your PARange finding -- it depends on
> it. The 42s -> <1s result was the 256x chunk scaling; the remaining
> <1s is what the conditional flush removes.

Thanks for the analysis!

I completely agree. My finding was only a small part of the full
picture. I stopped at finding out the real iteration count and didn't
realize 3-5us is a long time for a kvm_pgtable_stage2_unmap() on a empty
table (thanks for the learning opportunity).

So, because there are no relevant tlb entries created in the first
place, the per iteration TLBIs and barriers are mostly doing nothing
useful and cause a 10x slowdown.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Shuai
> 
> 
