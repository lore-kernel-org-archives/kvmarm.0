Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26166340D82
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094551; cv=pass; b=PwToEQRbZVbXrSLhhSpsmTI4aKNioVsefy19wzQo1xXytlWbAR3tWZ9TemMjT+hrVt9Uqtiu6V2TQswYDQpu/1Vy9trKIk7XKayeeNjqT5Z+m3mMsIXUUe8kmDb3VZal7r7Q6NkI4bDddohwaG1k0taI8+R9sL88hcnUZ0vUr7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094551; c=relaxed/simple;
	bh=28sDU1NjN9IpnZX+72ksOxuLzXREN3dgwwlZw7ix/xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AX9P37h41WuASaDnOnr2kdsUuiHInvraFhnmH5Mrh6R7Nt3blabMXkCM9BQ83/Jym0FiVLYQGnfoIuSl9/Gxw7VslR1GIf572rWZZEY/qdRoMh0DiaV1YxftW3emayOVnCC9ttnev+hSgxf6RJEy77WpLYPih9FzaFbMaVYIwRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pZEa38DS; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pZEa38DS"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50299648ae9so360161cf.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 07:09:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769094549; cv=none;
        d=google.com; s=arc-20240605;
        b=YnRRB+hPq8hCkmRaKUznuwCqP2VdQM0GwKK7wlBI2tb9qYXDQdd7PSgadQ9hDuazSr
         eViAh0z5AwPgOas5J20rDhFOKc133unqXyQd0n+2wTin72RpPREojXBsZlxbMzbVbfx2
         QqGURvpmxBiekEomW7ZIrgKuku0T1AWbXnTcO/acPs6PPlx2CJPRCFNXBrsijJPWUj6r
         HdWXCcHSpgvT44MSA7gkZLPngvGNNnNQLDN3IY0EeEr/N969Gos9TGI368GYvvs2o1Si
         KEdHLPa4UCqpOeL/w7clvHlrVlA16Zp6SvGqeWm1guK4ssFdJ0GxTa9rkke2VozHBpKe
         ASVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=id2ydjCWx625r+TrPtlTZ0CXmulo3m7nQYTh0pdFiQU=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=ISdOjCv6Y2feRgQtOl78ucV5nyW0jWfviRrgRZgCExrUFXuXDPtZh9vFDZKC6urUWT
         mfE7Fk37/Mq3JldaVFVGA162tUHjsmaXYTqdCLMQA4kGWe8QroY9toAgBpChlJYTkOWo
         6UhqnDZHVrolDPyLFCJiyP+5vjsG5vmohfp3NroD9kIA7dsag2wrqefz2gDAV0eTdjYC
         mmp3qjYEgj4HyE04P+4Zc4v+agQy922aZX3u+GnsfVbOsSbgGGbeJ1Se80ES8cqrV205
         xdP2fhBUmmnD2yimiy6ftiodv8NGfPswA+jtfzeANnoSYD8OyMpNBcrODkgjbQOcc9+O
         8yUA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769094549; x=1769699349; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=id2ydjCWx625r+TrPtlTZ0CXmulo3m7nQYTh0pdFiQU=;
        b=pZEa38DSgxZ+GCdHHvqzh24AL+7mbW3tLhbU8zRxvEqcsceHWk9K06mIgf3AjdSqSk
         x/C/N6p8h66JRbgQHjjtlvNWJ7ABfxiyGymCBu2Wgx8d1Nh7HOEp/bYVX3a/OFSjV2iM
         coZaz8dBo/x7V+b50AkuvZPaa/F+qKnmfDafrvdhviXyhqcqmw2fnCsLmqsLhkrdPKo4
         8Rxion+WRcj9WewfoRhKnNrBqOb9GjT9Xlnpw9osI3W9xqM5w+gKTuhD1JBhkKj+/RCQ
         sGCYLV1AM8QVOHzXEFFAa7zKYM2G76uh2X8ZPfp/pn9tXz4oo6OH7L93A6J2S5G817WS
         g4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094549; x=1769699349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=id2ydjCWx625r+TrPtlTZ0CXmulo3m7nQYTh0pdFiQU=;
        b=J2GbnsM8H2NkfHzTnHMZVsDoJOsgtgZg6Wm/DvRw1cqLFaj3iH7TU+FMnSwuZzwK3K
         k2CkyKNJc0M8SMiUeLL2l5TRVfrTTpuQ23XsZh/d6I3K5PjgZPDat2+C1jybtmBWnVAm
         q0njcnkicKlTQvlGLtRU9EjiS3Ov54l8rhqZjQEuHkLbjuttXOS8wXJEUvabBGPrfgrY
         vBc24tpUpV9PstI6/3Ax4u8xruV0Y5iiyGftF/7gtB7mxaa1s242sf8XvkrfNzRX4OyG
         inxnOXP8pobcImukIk9o5jhdqWr5dTQ61NvVyzd9MtKQidfYLkwWVKNKJaqnbkLRbCUw
         czRw==
X-Gm-Message-State: AOJu0YyqyWkJqPj//3YCvjzDmNV1YRgEzfHWgV1IWh8oUie2ViXesvFH
	/MCmWzqUUOgRq20CqpJuQEA9h+Hz5VyRLQ+XDC/8JrewYaf1FYmEZaLcILg95RmGCrLWV7VK5/K
	iLzYB7Zk1IEeRQA2u1Ko7mQjKE3Hq6Zd4sU64IzTJ6z9Du6tS5GO7/nygmVu51w==
X-Gm-Gg: AZuq6aLvViEVWsuwJIGZvRdMUn6e0gegKiZXW9olWmkVSWUNaKF2NtszX3bbkcqq9K9
	IiGdbn3Gr6oA2UjsLFfljsRYwa64Xw2HpHdGVDHmqjXIpnOWzEj9fSJ+cKUSEd0LOXjKj/RANAV
	TkwcPLfMyQD4nlDWcIGbotURpyzL7b3rkBDVhV0dQ/gJaSTzfrAiTVA7MU56JQ77fkpHDzi5kPa
	qXi3dEmVyQetwzBN5I1teItNzsoIC0ajprpob4qsyQSvaCdTEgQ0skZ9nF2UXwkbhTUW1lWh34a
	Q64GR8Fp5pH082msjQDBfPuhUA==
X-Received: by 2002:ac8:5a45:0:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-502ebc8d5f8mr11868411cf.6.1769094548427; Thu, 22 Jan 2026
 07:09:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119105651.255693-1-maz@kernel.org> <20260119105651.255693-3-maz@kernel.org>
In-Reply-To: <20260119105651.255693-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 Jan 2026 15:08:32 +0000
X-Gm-Features: AZwV_QjxHUhzUCCDzHZuSvN8AjYJVhmTDvMhmuADt9S7AlmbgmL_FTheXzhgjUs
Message-ID: <CA+EHjTzxbuyJcJRvwinrS0cqaVqMY03P6x6A8FH99onXphdjPQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Jan 2026 at 10:56, Marc Zyngier <maz@kernel.org> wrote:
>
> Plumb the MT_S2{,_FWB}_AS_S1 memory types into the KVM_S2_MEMATTR()
> macro with a new KVM_PGTABLE_S2_AS_S1 flag.
>
> Nobody selects it yet.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  2 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 13 ++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index fc02de43c68dd..9ce51a637da0a 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -232,10 +232,12 @@ struct kvm_pgtable_mm_ops {
>   * @KVM_PGTABLE_S2_NOFWB:      Don't enforce Normal-WB even if the CPUs have
>   *                             ARM64_HAS_STAGE2_FWB.
>   * @KVM_PGTABLE_S2_IDMAP:      Only use identity mappings.
> + * @KVM_PGTABLE_S2_AS_S1:      Final memory attributes are that of Stage-1.
>   */
>  enum kvm_pgtable_stage2_flags {
>         KVM_PGTABLE_S2_NOFWB                    = BIT(0),
>         KVM_PGTABLE_S2_IDMAP                    = BIT(1),
> +       KVM_PGTABLE_S2_AS_S1                    = BIT(2),
>  };
>
>  /**
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 947ac1a951a5b..3c5f399b1b986 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -659,7 +659,18 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>         }
>  }
>
> -#define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
> +#define KVM_S2_MEMATTR(pgt, attr)                                      \
> +       ({                                                              \
> +               kvm_pte_t __attr;                                       \

nit: new line?

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> +               if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)                 \
> +                       __attr = PAGE_S2_MEMATTR(AS_S1,                 \
> +                                                stage2_has_fwb(pgt));  \
> +               else                                                    \
> +                       __attr = PAGE_S2_MEMATTR(attr,                  \
> +                                                stage2_has_fwb(pgt));  \
> +                                                                       \
> +               __attr;                                                 \
> +       })
>
>  static int stage2_set_xn_attr(enum kvm_pgtable_prot prot, kvm_pte_t *attr)
>  {
> --
> 2.47.3
>
