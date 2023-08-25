Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F581A
	for <kvmarm@lists.linux.dev>; Fri, 25 Aug 2023 04:18:45 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-3fe2d620d17so53585e9.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692937124; x=1693541924; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGG0r2s/zKnKCX6e58SnLQEC0ecMvUzJNpn5TwLz2AI=;
        b=zkA/2r7mLpElDdvhlnfWycHdc6qFExlqKd56SoozjcHqFvYST3NVKNaoXCEnzzSBlv
         G8VHSQWs6mDBdmi6zoT4VgK9cunWE9JY+JtcVFZPFTmWJX2DAWwv5sE4gWvkkv6jzYbW
         lf0YhsdgbtDBcHhUayGqgNs2NGxQmkjnz7punIAcLrHAhihARLxBI6UXZCqK363/Ox1k
         t7p8Kv2JZ501K3EYJ1ngQZGamaUb5L28wYTTbDapZR1mB2ctmy7WWO2iyPRId9HSjOPN
         8NgSOOMU8NCHr6ciHbadYhXlHkTHQWQaYHbKq4nioWzhAbLyk/1Bt+Ts/WTnt+/WzDpd
         oG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692937124; x=1693541924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGG0r2s/zKnKCX6e58SnLQEC0ecMvUzJNpn5TwLz2AI=;
        b=Q6oXzgMqehYAsG1t3xlnCnnDv+OBnv7wmKlZ3KwKAGdQ0E2Boz/e8en3HD8E694B+c
         Ya5bSS+z9iDJMzAIKQZbrg4Q6DXkIRPpahZDmPdyhc525gQ2n7lN66Dx5agxz22lpiKR
         oNhpFlZcUNU8+bajjElTEUFunmNIdYAkn8BTsAeWdMF4iB8X1JkufzriMfM8leDyGV4W
         DNVf39/uKxeMN0uwyO1u3KJEB52fESYaEOvHFSLx7WnWOvskTmAJB8RUcVqqJouz+5MS
         2IMfHFgLffSPSG5RaSRtc/1DULQAFX7C2tYPt9desnB37+0Us43auMw9XCyLmij/zIu6
         XtQA==
X-Gm-Message-State: AOJu0YxMZtF8j4kJb5ZP8pJrdJPbwgrJkr/1gCqi8hQkf6NVViExRAxY
	omrm1AAE0Ek58UcdHSvgGk7GihOHyam+fpS8gPpS
X-Google-Smtp-Source: AGHT+IE2UsyQUsldYE5MXI+562lkXCqi1kpGWn1pc58IuVJzbLjK3nuhLqcGTqoS4Ye7ZrDQHBn4yggAGKJCIXL+yxM=
X-Received: by 2002:a05:600c:1d84:b0:3f4:fb7:48d4 with SMTP id
 p4-20020a05600c1d8400b003f40fb748d4mr82239wms.3.1692937123755; Thu, 24 Aug
 2023 21:18:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
In-Reply-To: <20230818011256.211078-1-peter.hilber@opensynergy.com>
From: John Stultz <jstultz@google.com>
Date: Thu, 24 Aug 2023 21:18:32 -0700
Message-ID: <CANDhNCo_Z2_tnuCyvu-j=eqOkvDQ+_n2O-=JKpf2Ndqx1m5GqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] treewide: Use clocksource id for get_device_system_crosststamp()
To: Peter Hilber <peter.hilber@opensynergy.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Richard Cochran <richardcochran@gmail.com>, 
	Stephen Boyd <sboyd@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2023 at 6:13=E2=80=AFPM Peter Hilber
<peter.hilber@opensynergy.com> wrote:
>
> This patch series changes struct system_counterval_t to identify the
> clocksource through enum clocksource_ids, rather than through struct
> clocksource *. The net effect of the patch series is that
> get_device_system_crosststamp() callers can supply clocksource ids instea=
d
> of clocksource pointers, which can be problematic to get hold of.

Hey Peter,
  Thanks for sending this out. I'm a little curious though, can you
expand a bit on how clocksource pointers can be problematic to get a
hold of? What exactly is the problem that is motivating this change?

I just worry that switching to an enumeration solution might be
eventually exposing more than we would like to userland.

thanks
-john
