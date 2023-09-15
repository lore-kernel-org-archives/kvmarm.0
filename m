Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7722F38;
	Fri, 15 Sep 2023 08:45:19 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1c4c7c1b863so142888fac.0;
        Fri, 15 Sep 2023 01:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694767519; x=1695372319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bL0AhYUxrdUzQj4Hs45z84nA3TJ4ToZSnUkbGf3bwUM=;
        b=Ajejk9TXgswhi6j8kMq8g3f8FFDrzZViM/NId2jM1xXaeci5V7x15fwAbt/W2ZcKls
         iaAaYWIsgglMzUDa6yDxVaX6XcDg8eLAh/+A1vVqqUFHm/rAKoYYn+7svpQ8quKBiYnY
         xN1Y1fPOtA5UTfP/eYRDbsnjgGFU9ypWWP7w7URlI5qmXA/0tQq0M5AwVqHXzOCpzCr/
         vR4hhgP2qYizjplDQ6sawRA3YV14TcH5ChjqX8qrMzu/s/yVS3HxZ+Rs7liH5PtSlrNb
         dYXXyGTOkf0Hf6Qzz0Ne9N+UxXMesGrZ/oHNlFZpGGePeo2FHwRAUNAPnJp8nsfW3LqG
         P77Q==
X-Gm-Message-State: AOJu0YxixFTXro4kTnE6+ml9+JGMz0IuVQXA+FBAfJ7KD+MQcsVpqGd1
	ePrzanZz62gMXXJu/oRhHTBxDdvOv6aw7nGVJOo=
X-Google-Smtp-Source: AGHT+IHl9PRzfbA8hGPGrt3+1ROWaBoHTLPlXkbCHBgq/t81poRMRxjJx/fiwhN8rIFqovs63lEpZzfcdrUxgqBUZyU=
X-Received: by 2002:a05:6870:4250:b0:1d5:8faf:2935 with SMTP id
 v16-20020a056870425000b001d58faf2935mr1048882oac.4.1694767518748; Fri, 15 Sep
 2023 01:45:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230913163823.7880-1-james.morse@arm.com> <20230913163823.7880-28-james.morse@arm.com>
 <CAMj1kXHRAt7ecB9p_dm3MjDL5wZkAsVh30hMY2SV_XUe=bm6Vg@mail.gmail.com>
 <20230914155459.00002dba@Huawei.com> <CAMj1kXFquiLGCMow3iujHUU4GBZx2t9KfKy1R9iqjBFjY+acaA@mail.gmail.com>
 <f5d9beea95e149ab89364dcdb0f8bf69@huawei.com> <ZQQDJT6MOaIOPmq5@shell.armlinux.org.uk>
In-Reply-To: <ZQQDJT6MOaIOPmq5@shell.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 15 Sep 2023 10:45:07 +0200
Message-ID: <CAJZ5v0jUQ+4G5ArYAtu1gvYF4356CK_QVTO4oWn0ukwdOiZaHA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 27/35] ACPICA: Add new MADT GICC flags fields [code first?]
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Salil Mehta <salil.mehta@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, James Morse <james.morse@arm.com>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "jianyong.wu@arm.com" <jianyong.wu@arm.com>, 
	"justin.he@arm.com" <justin.he@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 9:09=E2=80=AFAM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Fri, Sep 15, 2023 at 02:29:13AM +0000, Salil Mehta wrote:
> > On x86, during init, if the MADT entry for LAPIC is found to be
> > online-capable and is enabled as well then possible and present
>
> Note that the ACPI spec says enabled + online-capable isn't defined.
>
> "The information conveyed by this bit depends on the value of the
> Enabled bit. If the Enabled bit is set, this bit is reserved and
> must be zero."
>
> So, if x86 is doing something with the enabled && online-capable
> state (other than ignoring the online-capable) then technically it
> is doing something that the spec doesn't define

And so it is wrong.

> - and it's
> completely fine if aarch64 does something else (maybe treating it
> strictly as per the spec and ignoring online-capable.)

That actually is the only compliant thing that can be done.

As per the spec (quoted above), a platform firmware setting
online-capable to 1 when Enabled is set is not compliant and it is
invalid to treat this as meaningful data.

As currently defined, online-capable is only applicable to CPUs that
are not enabled to start with and its role is to make it clear whether
or not they can be enabled later AFAICS.

If there is a need to represent the case in which a CPI that is
enabled to start with can be disabled, but cannot be enabled again,
the spec needs to be updated.
