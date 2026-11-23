Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461902;
	b=Akks8yzQiMl5ZR1t7Ct/dpKXG8QulZI7au36KXfN5VvGTuICv22yyeH4CG3BcKgKd+/P
	 6wi1OGw4NAyjlUHNc94G0lkZHUniqRg6jFWVVAU8JgBPa1ZhlulIgpjoO19T/ebnRSX18
	 2PSgCC/kRmCo/a3ivriQvn0tHP3BymofXRNMegmluY/riN/BuktSG1vrpvR422oR6z4ir
	 C5GVM29xCjA2IFPRAUj47dy1iOSSyZ2SycpX2hm1lE2lcCSfgPtlVoX/q+lbNUfwC+Ncv
	 NhEERJMy5Dugb0gnIIfKnYlGgdKkQEdp38l1m6HVRUfPS8qxL0BZzOozWm7aW1+/iVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461902;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=VTayRZy96830KSV7f6wsXnSstyeYaZLryI30VcYM53A=;
	b=WmgyBt4LrsEjMS3FvlLgxbQ4VsFFXFet2HPjpbKycNr/v9ivUBFMnYMjLHOSeYDaZ6mt
	 oyNXI7XvFLG+dX5pyxk+CGjRuHzBAKFgE+tanYxW6cJgYG+Edq9sUwWIPrzfv8mxedD2e
	 60mwpivVbDljkLL4JRLaXL85K/lrDY0hdg6lAcBU1dD2e311iI1W1LQrAhjhBBtiwZ4rg
	 vOIwaJ/jNrNmmouCg7G2JM8NN/LxXEwxm9+BWw+JiPAk4kQpVplsxeM0bjMlcDyFqxY2j
	 rCkMAmf56zWNQ/WL3kVISnGUdf8PtHE7ROEXgE0KNurVUr2KBSHDGTcMb3Axl8QdAHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=avj494TK;
	arc=none smtp.remote-ip=91.218.175.188
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF9606A31A
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 19:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0DF9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=avj494TK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=u4m8lL2KdbFjVQEXYzTGdkreUDCwR6VcjSIzYNXl6Dc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795461898; v=1; x=1796066698;
 b=avj494TK6psRmNsw1FLAjpFpfUQVc5GwwdRWd45Qu90GIUhOhauqSNwBDLKFwDKUOF+76XhY
 +dIHbgKqH+lZRlAHQ1QJa170FFQLb3ugRfG4HVVy39VYCIOxGqaETKaexR/7hL/F8B5WrKCbHgn
 egm2+9KwtO4rFnYO+7h6QRLU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f4ed4eb880d2b753;
	Mon, 23 Nov 2026 19:24:58 +0000
X-Mizu-Trace-ID: f4ed4eb880d2b753
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so12297e87.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:24:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFyfpzk+OVrY3w37LYlXQQCJ15U8U8hajm4qqgZlF1AsdserKY9Ij/H5vuFlpsRPBDTbfoH92A=@lists.linux.dev
X-Gm-Message-State: APuU4Z/sj5cGPerG8ZuaBMo8tGhs7h3hyMgSKAdTMajapAENyoui/Ejq
	6f3yh3DpzbH7UB5SHk4NB+BAMJV+O6GlKzAcPQDbf8LHVuF7/brmaPdFtvpIs74XAIqI+6BVZW1
	OrmsfTOvFlYuaaaQaPnQXvbpcbDCmVJBz8GLK2IQ5
X-Received: by 2002:a05:6512:3a87:b0:5c1:543d:2e3e with SMTP id
 2adb3069b0e04-5c21a249a25mr260653e87.7.1795461892671; Mon, 23 Nov 2026
 11:24:52 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-2-vdonnefort@google.com>
In-Reply-To: <20261117174403.58762-2-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 19:24:16 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyCo3oUiRUeLQ_YStLAzmD8J8i1kJD4H8qYLyn5EHdp=Q@mail.gmail.com>
X-Gm-Features: Aa3M54qeQzSvLkH5nDFzJvMHktdafiAhP3uLr3VXVmWB1KOnGb85PRMxO-t136I
Message-ID: <CA+EHjTyCo3oUiRUeLQ_YStLAzmD8J8i1kJD4H8qYLyn5EHdp=Q@mail.gmail.com>
Subject: Re: [PATCH v4 01/23] KVM: arm64: Prefault host stage-2 entries on
 block split
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 17 Nov 2026 17:43:40 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9c83837b184d..dfbcdd3d91a4 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
[...]
> @@ -1053,6 +1095,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>          if (!childp)
>                  return -ENOMEM;
>
> +        if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
> +                stage2_map_prefault_idmap(ctx, childp);
> +
>          if (!stage2_try_break_pte(ctx, data->mmu)) {
>                  mm_ops->put_page(childp);
>                  return -EAGAIN;

Should kvm_pgtable_stage2_annotate() end with a dsb(ishst), like
kvm_pgtable_stage2_map()? With this patch, it installs valid leaves in
the host stage-2 too.

Cheers,
/fuad
