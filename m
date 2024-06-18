Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05AB10A16
	for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 00:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718668879; cv=none; b=eSCfvJIOHCuMBLuYSZrWYmbNkXpS2vgrgDAbEZ7FCrh1zJMcJioIeY51MjGxCRVGXhZqjGFedL9d8gmcLDdj3mRgGKDoZCDQ4dmQBPlh0NqRmYF86ny+OiGBC6Tb832YbnA83B+OGdPJi5X5h72vS3uAylku81AGDFTItO/PYz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718668879; c=relaxed/simple;
	bh=e/6DXxfSmYa3PcUmKtpMGJIGbMO7nKFl8LeS2R3DEGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Su2ZzimMgMyvn84EVB7Rhkk0Ej8w9WKUMMQHRuhGuBp5Mb76nUuz6FkCGy2nLu/rdsH0k8MuCM1RvcqGZS3TTCOiPqKl0Ccy2VoZimRAzc79nyzg6FuF/hMOe7IXlSNjQGweKy2AQTj4TTLsSoYofnlHdld0RYQ+4PadDZqRH+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cqe3OH28; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cqe3OH28"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-443580f290dso67231cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 17:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718668877; x=1719273677; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYJUxDNTjiWQv0Dn1lpauSNYmPE3A/rHJsXpHH3eFP8=;
        b=Cqe3OH28gyS+vL0FkjXh+Vce+M7p8avLMJHrsbUtW+rdoABQfQcM6hJLhgBXZauZ0g
         hLEx+NuWLHms/5bgkF6cuSIH7LsRwbhtCmLhM6v0TgHfQ4L822ya5GzPQbd/E3vnoElf
         BZrt9svOyWccgM2PMsLniqWKR2nkVlcZ5LyI9aHwGMLHx2I83UEQHrm5hsiAgh5SlvJp
         2aZ2xWBfhO1aQOSKJRjIH01zsUtZmLwVcuT5C4rDUsyIsK/RMzi9gu0JoIzcmd1A2+ed
         v0yQzyCyYo7bIyMf6Ze7+EruM8axBLDvMTB4hQYhHaHU+h7yBILSrMHeUYYRMS/xsl52
         XLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718668877; x=1719273677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WYJUxDNTjiWQv0Dn1lpauSNYmPE3A/rHJsXpHH3eFP8=;
        b=Yg5U7GuwRulzF6lRb337yHw2ZdBvFtvqyVHgRzvxnHffjRwgxTVpqpKHHcSjw9SA36
         5iSGw9DEvyQtVldVYDk98ljF1/4HNfcm5cyKazA8U3aSZnNbfhi/athWmSpQd1WXPu5U
         8FmAsaZuGz0eNVTSyjxlhJbJBa79zk8BAGeWezevGTvsZPA0dobSaxUfszJOgOfrgaht
         QINJ9rTk0woEo6MYtbB226ga+l6K08infcK1IKD+G8VqHcVtIhgzS9lSW+GB2/FfTVDM
         xrketXKsqylhAxoGccG6DMdY6m+/rUD5NFIGwU/epcGxfoRykj7/Izw+QXkpVM04MQsH
         ii0w==
X-Forwarded-Encrypted: i=1; AJvYcCX723Gqtj51iq2bXlSpt6d94JLXxtHbchL6lTBYgMpcfOPU+pTiO6Hu6YYBK3bs8kApz3MIPzxXOQTLJdxtPJt4jMkpo7N0
X-Gm-Message-State: AOJu0YxvdxqEty6PVa4rVFBLtGqwRWT/Lzo+6+Ip5hRGTsIyqTlS117x
	oF3GOIkNiFD+GkKpp3loiGLNrngjRPO9OmKbAlXus778Ivd4+O2fhjRdoyHO8pPZxoQcK1v0IZ/
	IYueyFgmvs72WxukmqML/uMrqKo7/w++hfB1A
X-Google-Smtp-Source: AGHT+IHL1VOVBEEYIsDFmk7aYzMKo8+wU/oagSvanZsj7KqgaXrEPucAwYquOmDWm0/JC3eqHJ8+6hozxzfwg6DHtB4=
X-Received: by 2002:a05:622a:4e96:b0:444:a09e:c60e with SMTP id
 d75a77b69052e-444a09ed740mr85851cf.24.1718668876650; Mon, 17 Jun 2024
 17:01:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613082345.132336-1-shahuang@redhat.com> <20240613082345.132336-3-shahuang@redhat.com>
In-Reply-To: <20240613082345.132336-3-shahuang@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 17 Jun 2024 17:01:02 -0700
Message-ID: <CAJHc60y67Be=XcJuy__2RN43WyN6YgukSAb0=T6TGwYHw+YpHg@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] KVM: selftests: aarch64: Introduce pmu_event_filter_test
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin


On Thu, Jun 13, 2024 at 1:28=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:

> +static void prepare_expected_pmce(struct kvm_pmu_event_filter *filter)
> +{
> +       struct pmu_common_event_ids pmce_mask =3D { ~0, ~0 };
> +       bool first_filter =3D true;
> +       int i;
> +
> +       while (filter && filter->nevents !=3D 0) {
Do you also want to add a check to ensure we aren't running over
FILTER_NR (I'd expect a compiler warning/error though)?

> +               if (first_filter) {
> +                       if (filter->action =3D=3D KVM_PMU_EVENT_ALLOW)
> +                               memset(&pmce_mask, 0, sizeof(pmce_mask));
> +                       first_filter =3D false;
> +               }
nit: Probably we can make the 'first_filter' part a little cleaner by
checking this outside the loop.

if (filter && filter->action =3D=3D KVM_PMU_EVENT_ALLOW)
        memset(&pmce_mask, 0, sizeof(pmce_mask));

while (filter && filter->nevents !=3D 0) {
    ...
}

> +static struct test_desc tests[] =3D {
> +       {
> +               .name =3D "without_filter",
> +               .filter =3D {
> +                       { 0 }
> +               },
> +       },
> +       {
> +               .name =3D "member_allow_filter",
> +               .filter =3D {
> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_SW_INCR, 0),
In terms of readability, do you think it's better to use
KVM_PMU_EVENT_{ALLOW|DENY}, instead of 0 and 1?

Or, if that's coming out to be too long, may be create another wrapper
over DEFINE_FILTER, and simply use that in the array:

#define EVENT_ALLOW(event) DEFINE_FILTER(event, KVM_PMU_EVENT_ALLOW)
#define EVENT_DENY(event) DEFINE_FILTER(event, KVM_PMU_EVENT_DENY)

.filter =3D {
    EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_SW_INCR),

> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_INST_RETIRED, 0=
),
> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_BR_RETIRED, 0),
> +                       { 0 },
> +               },
> +       },

> +       {
> +               .name =3D "cancel_filter",
> +               .filter =3D {
> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, 0),
> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, 1),
> +               },
Since the initial filter map depends on the event being allowed or
denied, do you think another "cancel_filter" case to first deny and
then allow would also be better?

> +       },
> +       {
> +               .name =3D "multiple_filter",
> +               .filter =3D {
> +                       __DEFINE_FILTER(0x0, 0x10, 0),
> +                       __DEFINE_FILTER(0x6, 0x3, 1),
> +               },
> +       },
> +       { 0 }
> +};
> +
> +static void run_tests(void)
> +{
> +       struct test_desc *t;
> +
> +       for (t =3D &tests[0]; t->name; t++)
> +               run_test(t);
> +}
> +
> +int used_pmu_events[] =3D {
nit: static int used_pmu_events[] =3D {

Thank you.
Raghavendra


> +       ARMV8_PMUV3_PERFCTR_BR_RETIRED,
> +       ARMV8_PMUV3_PERFCTR_INST_RETIRED,
> +       ARMV8_PMUV3_PERFCTR_CHAIN,
> +};
> +
> +static bool kvm_pmu_support_events(void)
> +{
> +       struct pmu_common_event_ids used_pmce =3D { 0, 0 };
> +
> +       create_vpmu_vm(guest_get_pmceid);
> +
> +       memset(&max_pmce, 0, sizeof(max_pmce));
> +       sync_global_to_guest(vpmu_vm.vm, max_pmce);
> +       run_vcpu(vpmu_vm.vcpu);
> +       sync_global_from_guest(vpmu_vm.vm, max_pmce);
> +       destroy_vpmu_vm();
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(used_pmu_events); i++)
> +               set_pmce(&used_pmce, KVM_PMU_EVENT_ALLOW, used_pmu_events=
[i]);
> +
> +       return ((max_pmce.pmceid0 & used_pmce.pmceid0) =3D=3D used_pmce.p=
mceid0) &&
> +              ((max_pmce.pmceid1 & used_pmce.pmceid1) =3D=3D used_pmce.p=
mceid1);
> +}
> +
> +int main(void)
> +{
> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
> +       TEST_REQUIRE(kvm_pmu_support_events());
> +
> +       run_tests();
> +}
> --
> 2.40.1
>
>
