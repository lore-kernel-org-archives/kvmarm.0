Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795858141;
	b=cyE+qbQEHB6KXglBLWBnQvVY3KiEDc8C/x+KrTI81UMOfj6NLs5tuPuU9BSMXW8Qc6iZ
	 CUDkQJK9ZIF5wP0wb4IXG4DOVdUIs0G+KoP3yHNKx7V0VXS1SddMv7HexH6TqWeluCr/X
	 jiW2BmPLUpue72dcEK34SmeYZyPuk/G2B725g2p0F5PqdtHGUxDlqvFOvopsbYb53rP4K
	 c3hyuCPxGvd7BbUiZDbGL05gnB29ICB9+NZKYDVQ1SVZ/Mwl7Azl77YeXxxxq+OpFSRVi
	 8G0yEf6Cirr/xuyginTXy+KalCeneh98/lBQwrnvXGj3EC0RHui+SG9TdbzSsOh9RdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795858141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=+T4002pIw3rZ91yEJ61NQuLQSTrjOSKQ29W7WLBm84o=;
	b=r4Y976qX7GX8AiRabAO6N+WwKCQupPi86FS1Ljhl68cy7COFFNu0crKSTk7aftVdkIzc
	 dJcee2PzJizWxkM5ge0/L9OBKFEJ5cqQmYOtfB8HmWE82dmt0cKwDDIs5PlVWIyF5v0z2
	 jyT8QUdpGSKCE9nDQ2/h0naWn7CTwpQwWFWSRU5etwwkEtG8rpTGr5DGaoNs+06vQX9qg
	 DrqqfRuR3byZfGqnS6r5AABwmBdr7qclOWxfpxS8gthhHMOKWZI9G/YAFmPxghtoDyUGe
	 gkSsViMWDyKAlTm5i6kzAMRfyLYlB/4NCG5Lp+wX+EGtiDbFtM93rNIUdjX6SnTpsOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=T+B+CzDB;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD6E606A31F
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 09:29:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAD6E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=T+B+CzDB
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso7832970f8f.2
        for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 01:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795858139; x=1796462939; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+T4002pIw3rZ91yEJ61NQuLQSTrjOSKQ29W7WLBm84o=;
        b=T+B+CzDBbgmOBbDXp8E8xZotufbo/ugkIh57ynvSyECYLGKafRa/1a6iz2z3aGenmW
         kR1zqNDoTfj4JL+n6E/HHK1dbTHNr1NzCshnHDxj6vf67AvfyoXJaCEzB0LHyJlHewrK
         dWiEDgoo3ukIu0SBVB+qHBQnm4xtmdcprSPL9n8e2rNRg7kl8/q8WqlKHsz9K0wE1tgM
         zeCM5ZzahMvVUXXAH65ziAoForEKBVJvFaac9glJ8ju5JkTJggJppumnUpSERUcteuLe
         kdtkggJtA0JWdkE1x9tff0uKmk3wUtRI/TLIgKaOtP7A7f7+ysRyHW6Cyar8CJge7MXx
         DnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795858139; x=1796462939;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+T4002pIw3rZ91yEJ61NQuLQSTrjOSKQ29W7WLBm84o=;
        b=QPskiMW5DpHxVNd8H8sp/6jGrTvYzOhrulPYWGuQVMD2jSxlKrnvQ7vmIJu8JTwb1+
         yEajCS7Le+eXZB6u9m5POqltO+8tU6HPqMXpoey+lowpOPRCFSCvEDcodMKnaIv3W/JX
         q5lulg38jKh0EILo1vfeKKITpXFUZFMyvDjR7TwAERTpUFQ09wqFUT4ZQCgr+jZANvYk
         r9CyT3D81DcWlMeRAtZc5E4e5qa1pjb0I9sTqrP2dTVHEkgKx9u0tWRki60UWMbP7FB7
         rj4RhatA78UDGpeg7FfH6IDcJAIrlpkZ/R/OlIOQE3OnYKtv4twOyfMV9nukwE47biBZ
         cndA==
X-Gm-Message-State: APuU4Z9BytrdeNA0ghKXzqG6W7cJNhA6Ma1f2yB6TikOdYA97rnKYHxg
	uzR9OhT5/5KkYpyINLrStgYBS0+oOXNOHdt6AiRFUMVSstv3LmQ7q8SU7HB2wvTwV8veeOuuhbP
	mBNEpbmlodw==
X-Gm-Gg: AZFdTZersebwHBXluVTtRzpyfBLaRv6AM7Ur8Io090PElD+uQvYk2pX/2kwNOqOBzzm
	ebuPJycOa+YB7ao5Z5rleJ4siALnwNtj5BTmynhg21hR64CPDYbopoBTtyF0l0Mee1AGiXqKoic
	BfgzTK2JCbIQRyiqop6PTKenlbxdbnuoBsd5DDXaSCa1xFCdzf8f1rpxoccCxNOxBxNtvukbPHK
	ljxYMJlq3pq7bEKm276hKYFu7F4nBvtuflHLtZMIBuFUUqAlOVkN1aK9IArAe4dTJk1aoU8Hawi
	VlTHdtvmBMM5j4FVZFmfV7vPFvBV+ypNfk8Bl4CBlPQxzTFif5AMxfZAjuRxihn2yOJrjB9zgpa
	lQhWQ6P07WBcvxvRO5Qox/mhoGjfAixJgvocQFD+3sXjrFDc13//mJU2Q9QWMZsKcWUMHLCqMii
	nd64gE+1vmCK3LB/2ApI3DCHrCW/tmosQ5k8hmRKFBSFCx/fr1oQ6QGJWLDTUgSgu6yy3Nmf0Q6
	UeQOE3abNUYTlJQf6vcohTW6X2YbQsCD/F1shgrUQD5WLlxPwcPzriuEJddKahqaNq4Lc4aQJIn
	ZJVIScatjIdD3Cwylmw=
X-Received: by 2002:a05:6000:26ca:b0:4a6:4687:2ce9 with SMTP id ffacd0b85a97d-4abad5ac73dmr53013677f8f.4.1795858138844;
        Sat, 28 Nov 2026 01:28:58 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b1ed8b6a05sm31097138f8f.43.2026.11.28.01.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:28:58 -0800 (PST)
Date: Sat, 28 Nov 2026 12:28:55 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: nv: Fix AT emulation for TCR2_EL1
Message-ID: <awqe16An2pmXAmfO@stanley.mountain>
References: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
 <20261127-nv-tcr2-v3-v1-1-9c15c1cabe01@pereq.eu>
 <sashiko-outbox-237810@kernel.org>
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
In-Reply-To: <sashiko-outbox-237810@kernel.org>

Btw, sorry for not putting v3 in the subject.  I'm just seeing that
I missed that now.

On Fri, Nov 27, 2026 at 04:01:09PM +0000, sashiko-bot@kernel.org wrote:
> > @@ -1437,8 +1463,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> >  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
> >  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
> >  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
> > +	if (cpus_have_final_cap(ARM64_HAS_TCR2))
> > +		write_sysreg_el1(effective_tcr2(vcpu, TR_EL10), SYS_TCR2);
> >  	if (kvm_has_tcr2(vcpu->kvm)) {
> > -		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
> >  		if (kvm_has_s1pie(vcpu->kvm)) {
> >  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
> >  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
> > @@ -1452,6 +1479,17 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> >  	__load_stage2(mmu);
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but when __kvm_at_s1e01_fast()
> switches to the shadow stage-2 MMU here [1], does it need to call
> kvm_arm_vmid_update(&mmu->vmid) and check and update mmu->last_vcpu_ran
> the way vcpu_prepare_mmu() does?

Patch 3 does the VMID stuff, but it doesn't handle the mmu->last_vcpu_ran
check.  Probably it's simpler to use the slow path when they don't
match.

That fix would go in as a separate patch at the end.  I'll resend the
series next week.

regards,
dan carpenter

