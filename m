Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67133EC
	for <kvmarm@lists.linux.dev>; Tue, 14 Mar 2023 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678793667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kkLCoUCMpqcOHFaJffF6f0n5G6YobYmpdJv/U4OkHBM=;
	b=Rq69e8VPCEUqdPl0hlSrQOR6y/VvOjhH4fgF6E8xjRVi1eulKM/PuA1SiSA1pUnNUAH5rn
	Jk+Npv/KpGtVyyKnQP7eZGsRJ5hAxVoIvrzmGfq8i/GPl7u2eOqi2++mBZ7RmGEb8+I8MW
	hWT3VijMwwjHO4nLgNZGvAeArjtE4lA=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-EbdvtGseNPO2fpILhExkeg-1; Tue, 14 Mar 2023 07:34:26 -0400
X-MC-Unique: EbdvtGseNPO2fpILhExkeg-1
Received: by mail-vs1-f70.google.com with SMTP id e28-20020a056102225c00b0041225db8896so4800704vsb.14
        for <kvmarm@lists.linux.dev>; Tue, 14 Mar 2023 04:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678793666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkLCoUCMpqcOHFaJffF6f0n5G6YobYmpdJv/U4OkHBM=;
        b=UVc6RHNHmLwdVSMlEn9BRsF8yxZUThBzBvfMrxWvuyh45uG3ITf0F652+HF1PH7bjM
         uiuGVesji/E8PxfpllfT3gpyPpieFfZTDfNbg17ZZ2rwLLQyy7LVZE/cvX28oCvTntZW
         6bs8xEuIxpD+N0XYOhZOBH6iFCFr8pLE4hrdUVBXHMQ4S94RBdTBrYj61A7uyfwTjRuO
         At14byWX3zSvYuj0IEpVsNmNi/0yr1TCJimzAk74U7bRCyf5fBtbPZujdknjWzxepGqT
         HkLlLezeorExVayBa5DlNFBJGaLVG4itkNMlg+Cg6i5aCcAHTqIYZbZ69Fg9em7PUmci
         nI8Q==
X-Gm-Message-State: AO0yUKUFCoS7c6VMemky1hkWr16PfHYsOkM6haA6ZuhGc2hd2Mn8savk
	7fCkKBGj396ore0XKMG1WTnVq8yS6BAksBDyzoWHNQYa7RqE1g5rGw2ADkwwPrkm61E7+o+jEze
	F0cRZQ6BHEbJ6kvKlJ4ZzFVNegcpBHiwn
X-Received: by 2002:a05:6102:15a:b0:425:b211:3671 with SMTP id a26-20020a056102015a00b00425b2113671mr427734vsr.1.1678793665922;
        Tue, 14 Mar 2023 04:34:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set/w+sR9/GMNzZjM3wzMEhNKJTIhp0f9AHhm3KvhR7TM8JlTerQD5v60MTqgl5o4P2QZ8Cnr8/3wR0nh/OO0yi8=
X-Received: by 2002:a05:6102:15a:b0:425:b211:3671 with SMTP id
 a26-20020a056102015a00b00425b2113671mr427724vsr.1.1678793665678; Tue, 14 Mar
 2023 04:34:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZAz1duOOOTu+5LW5@thinky-boi>
In-Reply-To: <ZAz1duOOOTu+5LW5@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 14 Mar 2023 12:34:14 +0100
Message-ID: <CABgObfY1sL8JMUwf1JeJrmSncKo7OoCZe2sGh8m=XxH1h7Kp5g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, reijiw@google.com, joey.gouly@arm.com, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pulled, thanks!

Paolo

On Sat, Mar 11, 2023 at 10:41=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
>
> Hi Paolo,
>
> First shot at sending a pull request to you, please let me know if anythi=
ng
> is screwed up :)
>
> A single, important fix for guest timers addressing a bug from the nested
> virtualization prefix that went in 6.3.
>
> Please pull,
>
> --
> Oliver
>
> The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4c=
c6:
>
>   Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.3-1
>
> for you to fetch changes up to 47053904e18282af4525a02e3e0f519f014fc7f9:
>
>   KVM: arm64: timers: Convert per-vcpu virtual offset to a global value (=
2023-03-11 02:00:40 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.3, part #1
>
> A single patch to address a rather annoying bug w.r.t. guest timer
> offsetting. Effectively the synchronization of timer offsets between
> vCPUs was broken, leading to inconsistent timer reads within the VM.
>
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: timers: Convert per-vcpu virtual offset to a global val=
ue
>
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/arch_timer.c       | 45 +++++++++------------------------=
------
>  arch/arm64/kvm/hypercalls.c       |  2 +-
>  include/kvm/arm_arch_timer.h      | 15 +++++++++++++
>  4 files changed, 29 insertions(+), 36 deletions(-)
>

