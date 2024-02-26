Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694951292E0
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708956859; cv=none; b=LjuWV7zjOXWq2a7ZUjF61AzJCCxnxaWYraeb+Jt19bhzyPUrVdgWNFahVsMhvX1AOJatvoC84p5wcEtMNI5KsC05MShtnc1FXj6r0NONZRNnDCnQtlVWTw/PI59OOHlkTgxaHXWQxFqpLnyiSZu5FtyCyJoKowQJfSUxyn4ZFPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708956859; c=relaxed/simple;
	bh=u44Byk/geUoUPcRzHfhYBq+V1oPDjcBJaBLc1ZsjnIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mx3gLHeQ6ykm0PuCNnWacEuVdmSax3xMPyqKtbJBTdgtqCC9AmW9Y5BiPgzbURPhvHXE0mP3nMUgGIsS6Wv5KiHnGBGCxkwPcntDr8TlaG6zfageCBldUduMHbL/VJUTI5cFzZJ2cLS7pM0pOVyB4PhCBmVbsm7AdnYbS/G3Qrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HOPutJ+z; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HOPutJ+z"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-33d01faf711so3237392f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 06:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708956856; x=1709561656; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p3rNfB8zpjh0aw9Izv7iexnhaqVJohKYz0hpJMxpBiI=;
        b=HOPutJ+zDvJm4dpoURjs21LvpSqpu5tDkKtADd/eGDYlnBDSIxNVKSjg+xuPIN7tWF
         G2cThEz0V7Z6CvF4cCFVPFWVSWsnEEx+1hUA+WkK3yZnpiw/K+hyJCELnJ/haZl3Z1oC
         wqEUfZLzA5LjizhDyplIyaJ5UDekBqrGNMNxL00RCkxfWmli72yx5skCmk5i75I/Kub4
         JQvecwWvuEp4YAVgv7y9JiH9CSUXfsz3Bvd7Bq6VhsZk+FVd4GylL6XAtBSjiM5nA0W7
         UH0TyppBCKVi3ybpuP5iixA+mSGrJauPuX7nPGmm2R+2Jsg3xQY4kWK1tvcZpUQg8LfZ
         fzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708956856; x=1709561656;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3rNfB8zpjh0aw9Izv7iexnhaqVJohKYz0hpJMxpBiI=;
        b=dr9mQqqoqT6E20nBNvFKBaeYFxyE18Hi0itUMwzFJhhZAhmA1rEvHjwEzA3Fp9T4PO
         gX9vREpT6m0UBKoPRdMpInnlfgmplLM2pRXy58EGfeyocnjUpbF8+LwSXfKNTeqBnQCy
         4luNYfvcAcEO7MlHUcG6VYAAPHtGfdDYMp8yKrKTU5uPPXG2x9w25YcvJ5LWpS8VYOzm
         UvjoYTXVo6HVEAs3NsyUv57hXQQ0112gysRngSITXJ/f+yFqIoeNpJsb03R2H2LHCV0Y
         Ew10n7DZDoNMaYVxmNiYmXikbOlGEJJxIWb9b6a0te27oTXG3CvCr2C+qxbW3TM8Cn+Q
         CXHw==
X-Forwarded-Encrypted: i=1; AJvYcCUfq86sUSOpl4f04RdJjO2/1LNAYzsdvoUhZ0sE4uT5GwZOAE7LQ9We/p4rO4h2i/XjIfW4cCw8+TY3sxa6cdqYSqgxDq1y
X-Gm-Message-State: AOJu0YyZWRmOjPLBNi1bvwfVwC/Pm4Ke0sQFJaSmL78n9y8f6l+4qTUJ
	3f+80eF3/prwKdSlDEE/Qst7HlGt04hAXnlvMQTamo67LEgCbUhQmZby3+1WZtc=
X-Google-Smtp-Source: AGHT+IGGqhCN6MwrdQDfNMmeqLqNbnMnl58IjTum6M5weIQmD76LAqs6at9pGaBHNPVYhYArGN4FnA==
X-Received: by 2002:a05:6000:1961:b0:33d:7ea3:5b90 with SMTP id da1-20020a056000196100b0033d7ea35b90mr5370134wrb.65.1708956855773;
        Mon, 26 Feb 2024 06:14:15 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id bj29-20020a0560001e1d00b0033d81d9c44esm8512937wrb.70.2024.02.26.06.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 06:14:15 -0800 (PST)
Date: Mon, 26 Feb 2024 14:13:52 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 24/45] KVM: arm64: smmu-v3: Setup stream table
Message-ID: <20240226141352.GC1579460@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-25-jean-philippe@linaro.org>
 <CAFgf54qcTAru0Nvy1wH_tJMadOSW7Y3zEip5RTm+mtSa54Bymg@mail.gmail.com>
 <20240123194530.GA40099@myrica>
 <CAFgf54pAtSLWjaqhZShxzKkOLWFkjXmsmMk1P0TdXOUWhn00sg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54pAtSLWjaqhZShxzKkOLWFkjXmsmMk1P0TdXOUWhn00sg@mail.gmail.com>

On Fri, Feb 16, 2024 at 12:19:01PM +0000, Mostafa Saleh wrote:
> On Tue, Jan 23, 2024 at 7:45 PM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> >
> > Hi Mostafa,
> >
> > On Tue, Jan 16, 2024 at 08:59:41AM +0000, Mostafa Saleh wrote:
> > > > +__maybe_unused
> > > > +static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
> > > > +{
> > > > +       struct arm_smmu_cmdq_ent cmd = {
> > > > +               .opcode = CMDQ_OP_CFGI_STE,
> > > > +               .cfgi.sid = sid,
> > > > +               .cfgi.leaf = true,
> > > > +       };
> > > > +
> > > > +       return smmu_send_cmd(smmu, &cmd);
> > > > +}
> > > > +
> > > I see the page tables are properly configured for ARM_SMMU_FEAT_COHERENCY but no
> > > handling for the STE or CMDQ, I believe here we should have something as:
> > > if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > >         kvm_flush_dcache_to_poc(step, STRTAB_STE_DWORDS << 3);
> > >
> > > Similarly in "smmu_add_cmd" for the command queue. Or use NC mapping
> > > (which doesn't exist
> > > upstream as far as I can see)
> >
> > Right, the host driver seems to do this. If I'm following correctly we end
> > up with dma_direct_alloc() calling pgprot_dmacoherent() and get
> > MT_NORMAL_NC, when the SMMU is declared non-coherent in DT/IORT.
> >
> > So we'd get mismatched attributes if hyp is then mapping these structures
> > cacheable, but I don't remember how that works exactly. Might be fine
> > since host donates the pages to hyp and we'd have a cache flush in
> > between. I'll have to read up on that.
> 
> I guess that is not enough, as the hypervisor writes the STE/CMDQ at any time.
> 
> > Regardless, mapping NC seems cleaner, more readable. I'll see if I can add
> > that attribute to kvm_pgtable_hyp_map().
> 
> There is a patch for that already in Android
> https://android.googlesource.com/kernel/common/+/636c912401dec4d178f6cdf6073f546b15828cf7%5E%21/#F0

Nice, I've added this (rather than CMO, to avoid mismatched attributes)
but don't have the hardware to test it:

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 4b0b70017f59..e43011b51ef4 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -268,12 +268,17 @@ static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 }
 
 /* Transfer ownership of structures from host to hyp */
-static void *smmu_take_pages(u64 base, size_t size)
+static void *smmu_take_pages(struct hyp_arm_smmu_v3_device *smmu, u64 base,
+			     size_t size)
 {
 	void *hyp_ptr;
+	enum kvm_pgtable_prot prot = PAGE_HYP;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |= KVM_PGTABLE_PROT_NC;
 
 	hyp_ptr = hyp_phys_to_virt(base);
-	if (pkvm_create_mappings(hyp_ptr, hyp_ptr + size, PAGE_HYP))
+	if (pkvm_create_mappings(hyp_ptr, hyp_ptr + size, prot))
 		return NULL;
 
 	return hyp_ptr;
@@ -293,7 +298,7 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	cmdq_size = cmdq_nr_entries * CMDQ_ENT_DWORDS * 8;
 
 	cmdq_base &= Q_BASE_ADDR_MASK;
-	smmu->cmdq_base = smmu_take_pages(cmdq_base, cmdq_size);
+	smmu->cmdq_base = smmu_take_pages(smmu, cmdq_base, cmdq_size);
 	if (!smmu->cmdq_base)
 		return -EINVAL;
 
@@ -350,7 +355,7 @@ static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 	}
 
 	strtab_base &= STRTAB_BASE_ADDR_MASK;
-	smmu->strtab_base = smmu_take_pages(strtab_base, strtab_size);
+	smmu->strtab_base = smmu_take_pages(smmu, strtab_base, strtab_size);
 	if (!smmu->strtab_base)
 		return -EINVAL;
