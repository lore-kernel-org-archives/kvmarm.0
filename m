Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317AC11730
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 16:21:51 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1bfca0ec8b9so1872314fac.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 09:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691770911; x=1692375711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jKg5N5hbfx4G4nkzdYxZRRyiyKKwYaqTNfjWvIZvAs=;
        b=zc0817VRKQzK7Y4+3Am75b8whnYU7udMNvGIpoU3Z8J2LZooos78Pf0S7KAzda0Lbl
         RG/GkzpkzGwbakOyRZgdZXaZ2vQBMGuzWhbw5nNv/UY86xwVjSd3jU+3mS0fh3k8bGcW
         nzpItkgM6eqfr5PnZgX3guWO+mj+MUJRBGfneMpMQ7qzP54RiJVSYgHk7cpm/G/1rZS6
         gcSonm2agGtfO50G7iuyLBha4zeQOek8O4Zd1sCVenxENz7qicCc7mnNJm/9cP3OiFZL
         HQrM9N2GgkkdmgrXcOwrNpFnxDCZlrPrx3sHkqIbKeWq1bPlzqNeFqcli3sJJgTXp/UB
         2H6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691770911; x=1692375711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jKg5N5hbfx4G4nkzdYxZRRyiyKKwYaqTNfjWvIZvAs=;
        b=M/oChZqM1uOfvhhHfK9aOMc2un2mOiJt8hrhc9kZJmX+q8izoh743FoyDAg7IkO4k/
         tzuVvGiK0U7oDOxuWknIoQ8e0sVWq2tl42q3Y+DVE2JTB8FcdEHCqPUyySJ1fb4cwq15
         wcmOn9M1W+4qNo/fT0rahyr/r88hRf2MThuvvkNmJua81wsqz+Xiq/8xvOfVkF66k6CB
         FcseGj7IaaZ1mymXro7A+Q+TTG1IsXNA0YCK4jyAB63hr0wTYr4xjhG47Ib59yLxpQrF
         nu1s7DGExua/JmgtlKEjdI+GxLNaK8WVmq+j37jr6MSLWIP0W07hIQRm8m+3trGQ9AjS
         sWiw==
X-Gm-Message-State: AOJu0YzeE69jQflvRmG/hND+NxErU26F9MCrCcNjX1e07MWSGKRgesge
	+FUJPgrDiKkfsk4Pd+AWx59vH82iibp3avLgCUMSdQ==
X-Google-Smtp-Source: AGHT+IFmKhXLjuhqGamOxB2zZ0eLH2ZXhspjGba8e6gZO1qouLQ+iinPZIolJfdLMgZLIbhkI3norwAebs/9sotSWVs=
X-Received: by 2002:a05:6870:d782:b0:1bb:83ae:1512 with SMTP id
 bd2-20020a056870d78200b001bb83ae1512mr2750088oab.24.1691770910745; Fri, 11
 Aug 2023 09:21:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-12-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-12-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 11 Aug 2023 09:21:39 -0700
Message-ID: <CAAdAUtj-5PeXCH3tzdFYogg94aBRd4k7sr8x9SWD793XeFBS9Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/27] KVM: arm64: Add missing HCR_EL2 trap bits
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Chase Conklin <chase.conklin@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Darren Hart <darren@os.amperecomputing.com>, Miguel Luis <miguel.luis@oracle.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> We're still missing a handfull of HCR_EL2 trap bits. Add them.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 58e5eb27da68..028049b147df 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -18,10 +18,19 @@
>  #define HCR_DCT                (UL(1) << 57)
>  #define HCR_ATA_SHIFT  56
>  #define HCR_ATA                (UL(1) << HCR_ATA_SHIFT)
> +#define HCR_TTLBOS     (UL(1) << 55)
> +#define HCR_TTLBIS     (UL(1) << 54)
> +#define HCR_ENSCXT     (UL(1) << 53)
> +#define HCR_TOCU       (UL(1) << 52)
>  #define HCR_AMVOFFEN   (UL(1) << 51)
> +#define HCR_TICAB      (UL(1) << 50)
>  #define HCR_TID4       (UL(1) << 49)
>  #define HCR_FIEN       (UL(1) << 47)
>  #define HCR_FWB                (UL(1) << 46)
> +#define HCR_NV2                (UL(1) << 45)
> +#define HCR_AT         (UL(1) << 44)
> +#define HCR_NV1                (UL(1) << 43)
> +#define HCR_NV         (UL(1) << 42)
>  #define HCR_API                (UL(1) << 41)
>  #define HCR_APK                (UL(1) << 40)
>  #define HCR_TEA                (UL(1) << 37)
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
