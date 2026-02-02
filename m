Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D48C33A029
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022824; cv=pass; b=DZ1jr8ImBbP5EhSCjqwqWU/FLg5l2opomwJSHqyREUfESG9shHpk/0H9hfhyXQdwkKPEymF1a+0wXO1MlEKaDwnAYYdJC0qQ/AFmSjiRveB58cR2KjQMUzNQjI13x1ucy4gXpTv6KGp5ls8OQrTSw+kW3ZWaZmAF6g79sbBYohg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022824; c=relaxed/simple;
	bh=JEodHyy2alK2xyjbCAZvg8FB9ORG/DynBi9KzfpnERc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kt5oPL38iyBuTEZYPrmG/USG+YAAPsOh/yr0jX7kF1STjFbKUVTHJTnfAzNqkZoblpCuIoaV9lcaDWR1kHU10IhPsou/StnkgOgettOrmemo90RN1bJcgTDX1w2Sy4DaKFckuF0CEjqrtOkPmiVJdFCgd1Lopcc94tAt8S2RgOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jIOeRLmg; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jIOeRLmg"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-505d3baf1a7so933721cf.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 01:00:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770022822; cv=none;
        d=google.com; s=arc-20240605;
        b=TeK4uyIs6Mc4BcKIFMfj7v5GmTkhJCcYBpy5L3iPHnx9hJ91F9nlWWrCjzuqk7FNtF
         tH5keskhBQZis7fHKPrxW7BYwNIxhanf3+O7rg9bLzObMHrkaDeo5cknk89kowwwR0sp
         WdWIsMWq7NPKpJqxTfiWSCQ6YlSL/XkGc7YacmC152gPT+42D8spfpHgWxD8BbVcpWhd
         HEqPy4q7m3k2qGX3LQOAbwHqjD+vM01YKrCV0ZfjM9xvdQlhMhzJM5gQIwYCXjjUnXwn
         X8TfCp6hr9agg7yPENTZxw5Cc6bGR+flhYNdjihpnHHbWiMp8qxmXTcDwCXPWWWnr9R2
         mEXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mCcD9bj7awZZLZPuAnMOEAmooVssTLmcQS2kNDZinC8=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=IhqDyajW/CWVw8MtQYMBJp/isVXGhshu+HE6pBlyI7qO+iVPs/QjzffSaeaVLiHozS
         635Jc1dgptySy5nUmESLH5DpDnsHPs61UIHgJYM+BevULILCnl3TtNe7E07iE90E6cjs
         R4UcQMHXqIC/9EIqLuR5OkRD13s1zmV2QlMvowh0Tz9nR9edaYRIj9Ia9UP5Vn4tH+HV
         OC8mbdfQqVoGtfFOjt22fo+nAAKlonRsMRMMi3X1/x0qGyR8tWoxJtB64dH5r4f+FKg2
         pf/haiTmOKXzymHpfM5QdZvbXPiCDm7nWicpB9NcnS5aAHSgfP0iZYGjCkkr3VjyDrWz
         c43Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022822; x=1770627622; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mCcD9bj7awZZLZPuAnMOEAmooVssTLmcQS2kNDZinC8=;
        b=jIOeRLmgpdSTBNM5VWNbyoH9Gbq9QqH+mkdoCDWErXo+hfs+xBaD0jxbVWwOT8ADZG
         BIxpb8XZJgFs86EH4Z/i/l3y5E5recym4KBRrO06ijONfumsKwCfGHebSpHzQd5rqjpF
         2y+iyVksZIBDSu8L9XfceihDIAi7SLunqNc1/wZ/a4j8VPXVgYgsv+w1DmlaYFVfEuvH
         QGmRjdArAVRPAkI+YqO3i/QO7w4StZpH3EqPp8W4kOe0cwxwP/1T+LgIEjedWxXepc8Y
         rk1jn48ATvNUGH4knXqoGIjCdK/xgQNC0c6GMYf8Kw7rHZwaM1Z2dzWcDYeYoGDxuUks
         yPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022822; x=1770627622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCcD9bj7awZZLZPuAnMOEAmooVssTLmcQS2kNDZinC8=;
        b=vFX5mmlh5iOimjsU8xXRR89elWvGmACEGnLnoWszkM/etxQ56PJS9GF0PRz1yf1HpG
         ZQLtqOprrpEPA9WxUoxscEf25uvjRahiJ9HSJB01Px9x+i4vdpLjzz/4FRdkUv/h/V0s
         GftCdfSCJTdDnEBrYNJu/qukxbQ6oIs1csn5pchYj1eWuNrXExYTvyIt937d5Edgs/fi
         2gosqdQw+foQPxZgFuRG8zEMGuARw+oFwjm+61L7W+pBvgT9aN98aQPo4foY6vNNQh02
         Xp6NZnZqRZMlKB7i2fbBviYY3RzBKaxook5GNbl/+QQApo8c2NXb/tCNDPOs0+0BFMhV
         pojQ==
X-Gm-Message-State: AOJu0YwrGcs7hqMeBlqTXAO+H06qEvN3ntebeLj6UJf3i1SmzB1LQbAm
	cGdsgYHZ+lRtDBXcwVTBYnTNPC+QqzEbX6zVsCzRQ8NSUbE5OUIga9okEeAIPTFggtuOjgG9DKa
	kA7bYe6kvR2XAKqU6aUOHcaVIteauxC1yLlZhwQch
X-Gm-Gg: AZuq6aJCcSAQ7GwpIZS2k8yccjs99jp448U9fhblD4H5YN/lh7huW8b1icKpvNutjCF
	C/zB+xPMILqa4OtZD66lyW6/Zjub1yomBorknb6RHRrVuqus3Ka3LiXCgRM6y6Py1RvvpQCZExG
	HcEUhILE0cI1DX83dUTcYFXMSkQiJROoq2roFwRriq0fn5minJAJWWEl87We629NyYjkTDkl1mx
	7cYcRt4terfE2MLWqq0z3PoggaetuWGtoglw2r0wiHgIav80yEbcGOzzVn2RKBOhJjCw3r8
X-Received: by 2002:a05:622a:3d1:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-505dfb30e91mr17084781cf.9.1770022821656; Mon, 02 Feb 2026
 01:00:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-21-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-21-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Feb 2026 08:59:45 +0000
X-Gm-Features: AZwV_QiYpw-7eH_Ok5Bnjv2eot8sO20awaRxhk21veOJg4c86-z9Wey20QWTlg4
Message-ID: <CA+EHjTxAEah7N1myCgc-XRDjSFLiQcYHQtNjLWt=Ns_Rag6vPw@mail.gmail.com>
Subject: Re: [PATCH 20/20] KVM: arm64: Add debugfs file dumping computed RESx values
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Computing RESx values is hard. Verifying that they are correct is
> harder. Add a debugfs file called "resx" that will dump all the RESx
> values for a given VM.
>
> I found it useful, maybe you will too.

I'm sure I will :)

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/sys_regs.c         | 98 +++++++++++++++++++++++++++++++
>  2 files changed, 99 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c82b071ade2a5..54072f6ec9d4b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -375,6 +375,7 @@ struct kvm_arch {
>
>         /* Iterator for idreg debugfs */
>         u8      idreg_debugfs_iter;
> +       u16     sr_resx_iter;

Storing `sr_resx_iter` in `struct kvm_arch` effectively makes this
debugfs file exclusive (returning -EBUSY on contention). Standard
`seq_file` implementations should be stateless, using the `loff_t
*pos` argument to track the index. This allows multiple users to read
the file simultaneously without blocking each other.

>
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 88a57ca36d96c..f3f92b489b588 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5090,12 +5090,110 @@ static const struct seq_operations idregs_debug_sops = {
>
>  DEFINE_SEQ_ATTRIBUTE(idregs_debug);
>
> +static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
> +{
> +       unsigned long i, sr_idx = 0;
> +
> +       for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> +               const struct sys_reg_desc *r = &sys_reg_descs[i];
> +
> +               if (r->reg < __SANITISED_REG_START__)
> +                       continue;
> +
> +               if (sr_idx == pos)
> +                       return r;
> +
> +               sr_idx++;
> +       }
> +
> +       return NULL;
> +}
> +
> +static void *sr_resx_start(struct seq_file *s, loff_t *pos)
> +{
> +       struct kvm *kvm = s->private;
> +       u16 *iter;
> +
> +       guard(mutex)(&kvm->arch.config_lock);

My understanding of `guard()` is that it releases the lock as soon as
the current scope ends (i.e., when `sr_resx_start() `returns). If the
intention was to protect the iteration, it seems like `sr_resx_next()`
and `sr_resx_show()` would end up running unprotected. That said,
converting this to a standard `seq_file` implementation should remove
the need for locking altogether.

I guess you based your code on the existing code for the idregs
debugfs. I had a look at that, and at vgic-debug, and I think they
both can be simplified and made more robust [1]. I also have a diff
that converts this to use `seq_file`. It's pretty similar to what I
have for idregs in the series I sent out [2]. Let me know if you'd
like me to share it.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260202085721.3954942-1-tabba@google.com/
[2] https://lore.kernel.org/all/20260202085721.3954942-2-tabba@google.com/




> +
> +       if (!kvm->arch.sysreg_masks)
> +               return NULL;
> +
> +       iter = &kvm->arch.sr_resx_iter;
> +       if (*iter != (u16)~0)
> +               return ERR_PTR(-EBUSY);
> +
> +       *iter = *pos;
> +       if (!sr_resx_find(kvm, *iter))
> +               iter = NULL;
> +
> +       return iter;
> +}
> +
> +static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +       struct kvm *kvm = s->private;
> +
> +       (*pos)++;
> +
> +       if (sr_resx_find(kvm, kvm->arch.sr_resx_iter + 1)) {
> +               kvm->arch.sr_resx_iter++;
> +
> +               return &kvm->arch.sr_resx_iter;
> +       }
> +
> +       return NULL;
> +}
> +
> +static void sr_resx_stop(struct seq_file *s, void *v)
> +{
> +       struct kvm *kvm = s->private;
> +
> +       if (IS_ERR(v))
> +               return;
> +
> +       guard(mutex)(&kvm->arch.config_lock);
> +
> +       kvm->arch.sr_resx_iter = ~0;
> +}
> +
> +static int sr_resx_show(struct seq_file *s, void *v)
> +{
> +       const struct sys_reg_desc *desc;
> +       struct kvm *kvm = s->private;
> +       struct resx resx;
> +
> +       desc = sr_resx_find(kvm, kvm->arch.sr_resx_iter);
> +
> +       if (!desc->name)
> +               return 0;
> +
> +       resx = kvm_get_sysreg_resx(kvm, desc->reg);
> +
> +       seq_printf(s, "%20s:\tRES0:%016llx\tRES1:%016llx\n",
> +                  desc->name, resx.res0, resx.res1);
> +
> +       return 0;
> +}
> +
> +static const struct seq_operations sr_resx_sops = {
> +       .start  = sr_resx_start,
> +       .next   = sr_resx_next,
> +       .stop   = sr_resx_stop,
> +       .show   = sr_resx_show,
> +};
> +
> +DEFINE_SEQ_ATTRIBUTE(sr_resx);
> +
>  void kvm_sys_regs_create_debugfs(struct kvm *kvm)
>  {
>         kvm->arch.idreg_debugfs_iter = ~0;
> +       kvm->arch.sr_resx_iter = ~0;
>
>         debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
>                             &idregs_debug_fops);
> +       debugfs_create_file("resx", 0444, kvm->debugfs_dentry, kvm,
> +                           &sr_resx_fops);
>  }
>
>  static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *reg)
> --
> 2.47.3
>
