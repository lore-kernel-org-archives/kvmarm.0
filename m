Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E17E54CF59
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792100231; cv=none; b=Xjw0tCWFv+eO8oDdYnz1gSW/tDVcHFWFevpXvHHekkm/E1F5hC5a0WmG8790GJRvbSn92afMNzwgnkmGH4zIGP49Uj8FSqZ9rrPwPRK8fS69XWlcsARYTcP7TWdWt7ZDMdw4C/KMDHtQlGNbXo+aoyctwPlxZMxFfInQ1aPcvB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792100231; c=relaxed/simple;
	bh=386oVWfTK7j80sjNixNYLJd6ruHZ1xN4lGXGD+O8SHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUDP8y+BvssvEkXfmr2bLzknyUYtTp9cVJoDtSppjczZ4uTOSuLemHn7aYDMUxGD9FYzTJnG+PJajd90SU8S9woUCXRal0xHxu2olWJsb0F1go023pRHQH808SUdfAFX3snYSp6mLS+d12ddzepGIc/i/1LTUMYV2c0Ix6W18nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=apD5h0qT; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="apD5h0qT"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a18617ae90so23635e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792100226; x=1792705026; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3oR7WBo625HYQwcxrhw35THi++ot7WU5ktgUJV6FYhQ=;
        b=apD5h0qT8EQmyVi+gEZQABtEvEXTk9IqyrNB9fBvMq37IBU5/wEWRzrMfhB0AGn2o6
         V1ULmLrDFTikGD2dM5MiltdVPR+ylBzeGTfANGUvNmeWG6peBex6jbl8UCuE3OejGtG/
         M4AG/CQkD6N9qVj63M5lcBIIavv1aEKn2zTqKwHqVamCsCKSNSeoERC35axB5Jvru1uQ
         ppM2vg6rIjeoEFXjbYU8nUASsxquWeaR0CQtxSj/Xtt9VxZ5tACO5bu7oc3/Iuev459J
         8gSxFlL7vXBHtZ9iHXVfdgFt0dsJ+3hS+hq2KK/LGNg8NEujxmeffPfZG9pzsIrI4AeE
         5KCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792100226; x=1792705026;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3oR7WBo625HYQwcxrhw35THi++ot7WU5ktgUJV6FYhQ=;
        b=TKg/KQNWmRWcjV863S/+YEsNugFDP13MrxEMY2WLUPxoauep8GtrJyIwpfCd0jg4f5
         //4njaNr47W+iTAbSW7g0HXhujS6eL+f16plyjmq0dDKddw2WPLwv3XlmbxEx2yHK6Jj
         BAN8ANqwCfNLLY4ayIb5d/XG9I//BfR9pA/Pdn7CABEErT87qsys1ebVPv8lAbMBhLx+
         4/d4urbffD02v4TFX5wMiAIoHzZqtTuZQ4NWU/A91v6E9NQu/j0RsRR6prn7sFNJE5yK
         3qJsfRxBaQlezhqP1pK+iFjzfVYHldIgJHcjpwt2bkMlFY4xaTOPaeq2KKiRx+N00nDc
         Xglg==
X-Gm-Message-State: AFq9FYK2IEparAVzTXcGyaGKwhd2aMC134NCT4FO6GLDxSjV+VfTdSWz
	z+88uUiQPiFMW4ICW7HCc8V3TohvHfHk8K7qdU17zb3qR8RkVMZT75Ziiaq/U/0FnQ==
X-Gm-Gg: AYBFou3nVl/cQHQchDzX2Bigfz2kr5Ks0KNLPgcMpnDpc4ApzmKKNsRZw4cLQXD8g5T
	0qOH3H+WvUolLzghjR7la3UjzRHSCtyc5WLt60YrpmOW21ZfHh6Wjqy9sQOLYQrVCiLKIoIjQtF
	n5reP3JGSSCdutp0iyLx20oFypquGV+vVSurGZsdghYvHROSoD7EiBDsyDJc1JqvtOe4z687Fc/
	slc9wG5kid6hju402YQnm2TTh/3oyksPEapYe0c9eWs2YyjIbtU66QatgN2eQhSir4KdKKBKSQz
	JkesvcWhvJAyN5KfV1B6gqNHBlR4VS+abJp+6fAWwJcHzerZy6yjS7D9eaYzoR2ilnpwQOSptO5
	SRlyoLiEpUluT+cAt5Z7ncAySWpQpZJpOrZkeMxNGAaC+Ifx0qvobzYh7srArBIYkAXPJUuH7Ao
	MyQ30vj5b4ikKu5K8ew9wFhVyCsG9kydZz0TmXpXapj/vjinOIdczU1/jTWsCeYceouYySScL5S
	9UMKlWtahssyqEFA+XXXQsarFxlRJILBpMDGHpf
X-Received: by 2002:a05:600c:34cd:b0:4a1:9034:e9ac with SMTP id 5b1f17b1804b1-4a1c8adefe4mr144145e9.14.1792100225727;
        Thu, 15 Oct 2026 14:37:05 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9b8b5fsm106779685e9.9.2026.10.15.14.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:37:05 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:37:01 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 24/25] iommu/arm-smmu-v3-kvm: Enable nesting
Message-ID: <atFHfW4_1ZN1EYlk@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-25-smostafa@google.com>
 <sashiko-outbox-173401@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173401@kernel.org>

On Thu, Oct 15, 2026 at 08:34:42PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] iommu/arm-smmu-v3: fatal EL2 panic on host-supplied invalid STE or ENOMEM
> - [Medium] arm-smmu-v3-kvm: Incorrect EL2 WARN_ON usage for hardware timeout
> --
> 
> commit 5625f7b65b03ea88554c9ce7668b1dabbbb068b1
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Enable nesting
> 
> This commit enables stage-2 translation for the ARM SMMUv3 under pKVM
> by allowing the hypervisor to sanitize and control the stage-2 portion
> of the Stream Table Entry (STE).
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > index 01f23fce6be50..3562bb222f53e 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -443,6 +443,60 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> > +static int smmu_attach_stage_2(struct hyp_arm_smmu_v3_device *smmu,
> > +			       struct arm_smmu_ste *ste)
> > +{
> [ ... ]
> > +	/* S2 is not advertised, that should never be attempted. */
> > +	if ((cfg == STRTAB_STE_0_CFG_S2_TRANS) ||
> > +	    (cfg == STRTAB_STE_0_CFG_NESTED))
> > +		return -EINVAL;
> 
> [Severity: Critical]
> Can this error return lead to a hypervisor panic?
> 
> When smmu_attach_stage_2() returns -EINVAL, the error propagates to
> smmu_filter_command(), which evaluates it and returns true to indicate
> the command should be skipped.
> 
> The preexisting caller smmu_emulate_cmdq_insert() then processes this
> skip condition using WARN_ON:
> 
> smmu_emulate_cmdq_insert() {
>     ...
>     skip = smmu_filter_command(smmu, cmd);
>     if (WARN_ON(skip))
>         continue;
> }
> 
> At EL2 under pKVM, WARN_ON expands to a fatal breakpoint. Since the host
> can supply an invalid STE configuration that triggers this -EINVAL, could
> this allow the host to maliciously crash the hypervisor?
> 
> Similarly, allocating the L2 table in smmu_reshadow_ste() can fail and
> return -ENOMEM, which also propagates into this same fatal WARN_ON path
> during an out-of-memory event.

Yes, that is by design as replied previously.

> 
> [ ... ]
> > +static void smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
> > +{
> > +	struct smmu_ste_writer *ste_writer =
> > +		container_of(writer, struct smmu_ste_writer, writer);
> > +	struct arm_smmu_cmd cfgi_cmd = arm_smmu_make_cmd_cfgi_ste(ste_writer->sid, true);
> > +
> > +	WARN_ON(smmu_send_cmd(ste_writer->smmu, &cfgi_cmd));
> > +}
> 
> [Severity: Medium]
> Is it safe to use WARN_ON for hardware interactions that might time out?
> 
> If the SMMU command queue is full and smmu_send_cmd() times out waiting
> for it to drain, it will return -ETIMEDOUT. Because WARN_ON is fatal at
> EL2 under pKVM, this transforms a transient hardware latency or a heavy
> command load into a hypervisor panic.

As discussed in the last patch.

Thanks,
Mostafa

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=24
