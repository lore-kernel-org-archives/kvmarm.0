Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE55D15A6
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 03:06:50 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id y19so693858pgk.5
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 19:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677812810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGhwusBobxSy0Ximwk7sp5ZnC5ri+nh8363yR1Q/BSE=;
        b=ImXAB3gqENAj74ss8oVPqfvT8C+7j4TPbTqAkWJ9z7JNoX+DSWxEdiIWtIyJtwgj+W
         AqSrJcIlZzWxYJAfi2XpRIIVuyb/TsYxR/ZkY2EGM0lzOWvo8XPWoa8ChXeb7HhDMLBd
         FbQtrAgV08Ct1F+sTX89ZDoXso3zJ85S2TxdZM5zn4mF522N+A91LKRJW+uzuNmla76Z
         4gpoNAHjKwSQuItlaU9ke/6PX3t5VcLGDeQC0h98Jgo67KgiyHpOD4Cy13lx31gSjnoI
         HwIEBzEGQb0amE+RKiYOOMiq5phFiF2bVSwwkcN00bqSAHVmcvsv524vwFTOCNkxJmwx
         wzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677812810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FGhwusBobxSy0Ximwk7sp5ZnC5ri+nh8363yR1Q/BSE=;
        b=tmvxKIHYa7v/yGFJRnk6NAvN05wHk/1rydi6doPxGI5Qbt/BLDt406wwIPVmeeDKh2
         BAkrz2M97mWabh3tDbRbc7aHwsd45Yu9C+PQCJKVYWj32ic8J/Wk2hW/K/QJ0GJcXY4n
         sMBQuoCD3q7Z//kFguXv2StmKiozf9Rzmvw8BfX8n2m778U2CkCNSumqkCFPZhjKLhMQ
         TLEwYB3lLHjmHYbtXBZws0qwdxkFeHfcQhW30V2g3HEu/z5sLnJ9dYT9yPmBYVOMLJ1W
         EGAh9ATm28ik9asrsjvuSH3wilV2hgmvPjKcMr5KWnSgH0PEfSwssK8evEkC93KjKe15
         /vew==
X-Gm-Message-State: AO0yUKVaB3BVdpcJWHN+7IUyC1IPt+0YHHeEDV4TeaOqpt2T/8mXUpJr
	JecFHRayWamxQx5ZaLB6uyJ4DZ6WwEQd/XDY8/xX11XPdCpaO8Bh76U=
X-Google-Smtp-Source: AK7set/k+iYHrswIgrEMZtrD+gsZ2q/VNLmEyHTV85AMahzxzbfH5hXIwlMOXgX7+oFfOaydm3W7R2/NpiWbMrcRIcQ=
X-Received: by 2002:a63:7d1d:0:b0:4fb:1f2a:e6c6 with SMTP id
 y29-20020a637d1d000000b004fb1f2ae6c6mr9382pgc.2.1677812810012; Thu, 02 Mar
 2023 19:06:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-8-rananta@google.com>
In-Reply-To: <20230215010717.3612794-8-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 2 Mar 2023 19:06:33 -0800
Message-ID: <CAAeT=FxVyHVRTj_78Jebz9nsc79yfYcbOu2c2hcekJTLgKFFaQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 07/16] selftests: KVM: aarch64: Add PMU cycle
 counter helpers
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Raghu,

On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Add basic helpers for the test to access the cycle counter
> registers. The helpers will be used in the upcoming patches
> to run the tests related to cycle counter.
>
> No functional change intended.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index d72c3c9b9c39f..15aebc7d7dc94 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -147,6 +147,46 @@ static inline void disable_counter(int idx)
>         isb();
>  }
>
> +static inline uint64_t read_cycle_counter(void)
> +{
> +       return read_sysreg(pmccntr_el0);
> +}
> +
> +static inline void reset_cycle_counter(void)
> +{
> +       uint64_t v =3D read_sysreg(pmcr_el0);
> +
> +       write_sysreg(ARMV8_PMU_PMCR_C | v, pmcr_el0);
> +       isb();
> +}
> +
> +static inline void enable_cycle_counter(void)
> +{
> +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> +
> +       write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenset_el0);
> +       isb();
> +}

You might want to use enable_counter() and disable_counter()
from enable_cycle_counter() and disable_cycle_counter() respectively?

Thank you,
Reiji

> +
> +static inline void disable_cycle_counter(void)
> +{
> +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> +
> +       write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenclr_el0);
> +       isb();
> +}
> +
> +static inline void write_pmccfiltr(unsigned long val)
> +{
> +       write_sysreg(val, pmccfiltr_el0);
> +       isb();
> +}
> +
> +static inline uint64_t read_pmccfiltr(void)
> +{
> +       return read_sysreg(pmccfiltr_el0);
> +}
> +
>  static inline uint64_t get_pmcr_n(void)
>  {
>         return FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
> --
> 2.39.1.581.gbfd45094c4-goog
>
