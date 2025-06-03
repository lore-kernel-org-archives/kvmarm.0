Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A11DDC1A
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 18:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748976139; cv=none; b=LMAUAidfMz7+GrVfnsM3E07BDnoySwQdwij72hShpu6x6S0qUxASuDb+STwQ4q4iS8UtC13KT/J32aOBfL+LKwNnnLn0ENJeL/6n9oO93zzFSRf7AU//SjATOqMx6N1QkI0Ytx7sysNSRg2y+jRcr5YxKCaSLN61gqysaoYd7ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748976139; c=relaxed/simple;
	bh=unaTeA+8n2VXSBiudfH4XN5rKuisqcM11zEogAbIGG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qGpTlu4JMp5scBO3HqjM1lysHC3LwxO8xLYC9oVWNQ+qNdyA9ONWvbWDPLK4qemJeewlYjWesvj8LFRcSy6kBA2XJNa7ckWFr+OtucwNYOUqGR5Y8+SF80z+8ExWVf4OZ7FL5lVSbRKoyLIPjQfkREDoA4JrxgIwjoMMoWCOQZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g8/qe7oE; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g8/qe7oE"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4a58ef58a38so38291cf.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 11:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748976136; x=1749580936; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1y0ItqsfJ9yY2AvVWk8RWqZNjchO0jix99/+HKlpYY=;
        b=g8/qe7oEugmR7AP9/catkZ7r0jtJgiXJUmAicwWCq9lcuenOxX0/IariukJaWvVwEI
         BtOo8MGLWKcbN75SMsjuEthZNLYhT0EEuIm097X8DkPWsb7u3Li37eYmaexaADCnGpLL
         +Vi+qr84PCYSSLmLhnIBhUvj0ySQXknu0KOWukeHfmXAsLu1ky3En6PVATSvi+amUu0Q
         gKWrSH9Alj7gzvIcauQtNkYsoHsCoX2JwUnN2hYpT0sAVqRac04OocFkM2uwSXXN659y
         nuvVYRdyeCCqYF/TpFh1k9W35VcwlVorc8U871IvGtNXrkYl0gUyIgELqy4eij2HVBCJ
         fi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748976136; x=1749580936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1y0ItqsfJ9yY2AvVWk8RWqZNjchO0jix99/+HKlpYY=;
        b=Y4lOC7ESw7Gq3qqJ5vNpTng7xcf2FuiYp43mRm6gcUuPr/M6d7oWXXpU4lde2LMF7M
         iZTHvlI64+7zdjq2cc3dWO7gzSiIarLjEkkYDjQyck3M1lWosN3t9hoypSuggEcJF4+t
         iluSfcvj36HsOKherz1EmD9b081HrevC+nCEm0UPHW0wOWK3Nq9goplT0+j943D4ptUO
         dsQBZynBqjpgnEsJL9uGwPlVuF12MIjxvTn/bkpSFQXK2c1F3uAk+1FIftT43fUTQf4p
         P8+z2FTnpn5GULwdlWqPXeSZgGxXhVwuZtJIlA/I8xILAzhGEr/UiaScIthChnHWaCKU
         y0Jw==
X-Gm-Message-State: AOJu0YwvfaxK3sBgvxxqVS9SeqaO8hNiniNm9OH6rjjWYXeO/+EtZXXg
	1fcWHa5xI0Nsnk72xN4GiQfhoJfYYiW1yCT72K6FUp0BddZqiWDxP6YTmLtaScPn0O3ko7CPV5C
	/5fb8/hUNcaZ27zfHa8cxaJiaOueQISjwaMrghQpWAsdVn8LRb+8zuE4j
X-Gm-Gg: ASbGncuRjwMzak25wAmG3mB+y1FEl4LF40sT6eLYh5WBflDCjJ6dHyjQkfqx/nq3CSW
	NOPaqRw9Pqb57hegjLKe7vBSAqGecwjembnH5hzyvNMF2/F/r3vU77PeI1cpmRRopz0+GrK0BT2
	RkJTfLG7AjV31XSGvl6+ZuTowOjfYZYix3x2ycX8R+FO0gVynm+8pYnDZNAAB5ivF6Alq/urVUS
	Q3w
X-Google-Smtp-Source: AGHT+IG8e1vEaO73GtzK4ML1paOZP2fD0w5Yduv2kwCquavyWhlAjPwxpOb8xBnaqaEbwHyUg8GZF3PmwWZ/uGX6W/k=
X-Received: by 2002:ac8:5c86:0:b0:47d:c9f0:da47 with SMTP id
 d75a77b69052e-4a5a53eeaddmr82831cf.19.1748976135785; Tue, 03 Jun 2025
 11:42:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250531012545.709887-1-oliver.upton@linux.dev> <20250531012545.709887-5-oliver.upton@linux.dev>
In-Reply-To: <20250531012545.709887-5-oliver.upton@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 3 Jun 2025 11:42:04 -0700
X-Gm-Features: AX0GCFvjPDAq18E4LsUu0Rw15J75lodsuT2IX1-EKiIbFXzJOBZqF7Dh6-JOnVA
Message-ID: <CAJHc60zqCfFp-j=FPxkgKjPEbPQvtqN3z0pMG2wMsCAPvd=dwA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: selftests: Add test for nASSGIcap attribute
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ben Horgan <ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 6:26=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> From: Raghavendra Rao Ananta <rananta@google.com>
>
> Extend vgic_init to test the nASSGIcap attribute, asserting that it is
> configurable (within reason) prior to initializing the VGIC.
> Additionally, check that userspace cannot set the attribute after the
> VGIC has been initialized.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/arm64/vgic_init.c | 41 +++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testin=
g/selftests/kvm/arm64/vgic_init.c
> index b3b5fb0ff0a9..aaecba432dbc 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
> @@ -675,6 +675,46 @@ static void test_v3_its_region(void)
>         vm_gic_destroy(&v);
>  }
>
> +static void test_v3_nassgicap(void)
> +{
> +       struct kvm_vcpu *vcpus[NR_VCPUS];
> +       struct vm_gic vm;
> +       __u8 nassgicap;
> +       int ret;
> +
> +       vm =3D vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPU=
S, vcpus);
> +       TEST_REQUIRE(!__kvm_has_device_attr(vm.gic_fd, KVM_DEV_ARM_VGIC_G=
RP_FEATURES,
> +                                           KVM_DEV_ARM_VGIC_FEATURE_nASS=
GIcap));
> +
> +       kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
> +                           KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgica=
p);
> +       if (!nassgicap) {
> +               nassgicap =3D true;
> +               ret =3D __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC=
_GRP_FEATURES,
> +                                           KVM_DEV_ARM_VGIC_FEATURE_nASS=
GIcap, &nassgicap);
> +               TEST_ASSERT(ret && errno =3D=3D EINVAL,
> +                           "Enabled nASSGIcap even though it's unavailab=
le");
> +       } else {
> +               nassgicap =3D false;
> +               kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATU=
RES,
> +                                   KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &=
nassgicap);
> +
> +               nassgicap =3D true;
> +               kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATU=
RES,
> +                                   KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &=
nassgicap);
> +       }
> +
> +       kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +                           KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
> +
> +       ret =3D __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEA=
TURES,
> +                                   KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &=
nassgicap);
> +       TEST_ASSERT(ret && errno =3D=3D EBUSY,
> +                   "Configured nASSGIcap after initializing the VGIC");
> +
> +       vm_gic_destroy(&vm);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 o=
r V3).
>   */
> @@ -730,6 +770,7 @@ void run_tests(uint32_t gic_dev_type)
>                 test_v3_last_bit_single_rdist();
>                 test_v3_redist_ipa_range_check_at_vcpu_run();
>                 test_v3_its_region();
> +               test_v3_nassgicap();
>         }
>  }
>
> --
> 2.39.5
>

Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
