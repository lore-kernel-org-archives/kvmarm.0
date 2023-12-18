Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D921DA21;
	Mon, 18 Dec 2023 20:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1fae54afb66so108520fac.1;
        Mon, 18 Dec 2023 12:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702931727; x=1703536527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5muLLdvnEWK5GQ123Z96eJyI+5glad1JcNNdF8H1Jg=;
        b=LTP2lQDeFXEDUZVdCNQF8GdhHCbpicXo3ev5c7ZpIYyHj7UEVJqBggQUlfYjcV/Yy1
         tBikJ7RIv3bdzIMTymwM6YbnoyDlUJ8+9LiGTlnSJ56crMJwWO3HUVAuLVinJZyFGYJB
         nH6cUvJi/ppxi6hjtFj8n90KdcsAcjDx/9NP/4B8HI7NQ2GZIPeCDiDi/9y/JxA5fR2Y
         wyu2R/H9GjZmUDHJCLUny8alPzDwIsc5jq1ONqo63mshxi4r2wVnrtHG6rIKxPlDMlfF
         QjSvAEm7wnvH7VaNTK3A+PV7cX6rKu+hMSFDAEgzmYUoybiD2iuwffkmz1ZUkKzi3FZq
         YTWw==
X-Gm-Message-State: AOJu0YwQ9pfWrr2hIc6R04yV4yQp4DFRsipNkEtyA49k8ixElHQkft1I
	2yrQDfyCJNe4GWTqCQA4eNHriEhXle8RYL4cvs4oTkLA
X-Google-Smtp-Source: AGHT+IF1MjB6QbmwWfc3T+5pLabp0AF+8g7RLCoeqeEABS9CAvETyoAN6o6rB15S5OlZOByT2E647igWVuJN9yCJ/4I=
X-Received: by 2002:a05:6870:71ca:b0:203:e75d:a2c2 with SMTP id
 p10-20020a05687071ca00b00203e75da2c2mr729668oag.1.1702931727130; Mon, 18 Dec
 2023 12:35:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZXmn46ptis59F0CO@shell.armlinux.org.uk> <E1rDOgD-00Dvk2-3h@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1rDOgD-00Dvk2-3h@rmk-PC.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 18 Dec 2023 21:35:16 +0100
Message-ID: <CAJZ5v0g9nfLrEf9u4Ksw6BOWJQ9iv8Z-O8RsLU6jR5zk0ahxRw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 05/21] ACPI: Rename ACPI_HOTPLUG_CPU to include 'present'
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	acpica-devel@lists.linuxfoundation.org, linux-csky@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org, 
	linux-parisc@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com, justin.he@arm.com, 
	James Morse <james.morse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 1:49=E2=80=AFPM Russell King <rmk+kernel@armlinux.o=
rg.uk> wrote:
>
> From: James Morse <james.morse@arm.com>
>
> The code behind ACPI_HOTPLUG_CPU allows a not-present CPU to become
> present.

Right.

> This isn't the only use of HOTPLUG_CPU. On arm64 and riscv
> CPUs can be taken offline as a power saving measure.

But still there is the case in which a non-present CPU can become
present, isn't it there?

> On arm64 an offline CPU may be disabled by firmware, preventing it from
> being brought back online, but it remains present throughout.
>
> Adding code to prevent user-space trying to online these disabled CPUs
> needs some additional terminology.
>
> Rename the Kconfig symbol CONFIG_ACPI_HOTPLUG_PRESENT_CPU to reflect
> that it makes possible CPUs present.

Honestly, I don't think that this change is necessary or even useful.
