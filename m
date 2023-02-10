Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5663AB
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:58:49 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id n13so4266536wmr.4
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bvBG9ca92jYkJz3+IO9cCEyUcRP6k+bZzqDzIUYmZjQ=;
        b=HK+qzuC5d2RclQ8Pm2S9sVWA2HP7CRYTtKiSJN8HKHhqUeZ9KShks13w8PUjOsVisy
         S5Pt+YtUcdwmt1K/dxY4FL0oB40ZzzHSxrRsayXxNF6BhIoEugtLe63kl6wZnf7376qS
         +NrlEsFk0CxxRB/sk7ikVZU1Cm2QdlC5Qpz7vkvXMjHKQzG0KYbtr7W4AgbAcSO1gkVV
         ZatsAG0RZ4ZP9QUoCoT6xk8j+4D2Spl4aV4qiQ/b7rxrG7njTd0bjXNjdXe8SgtYG2p2
         QWCxGvVALP34ApkjiBry/37Cr2C76CNCVlttTGZqvZDcaR4BiF69i5RV9WNfSRXLJOlI
         yIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bvBG9ca92jYkJz3+IO9cCEyUcRP6k+bZzqDzIUYmZjQ=;
        b=Pb60PAABkAmCU7V/LogxP9yvRVPDR0Up2VVJ9D1maj0LeqnTUD+8KJQDTr4a4+AjxA
         gkCeHsBXmO2UgUaE1RGpDyvWmthfT6O6AdxQFF4VQuAfHqLRcb7NO0r6O08CDzeynRMg
         Wco4HsKTpmgZ7RmkV3robfQX2ujJCPU8+hMI8Ip+BKEIU5AkWX7noZFU01xn+ORqxqUl
         TDDqzKzxL7J4eKArLCNjZuT7MtDg9fThK9fNDhTn90Y6hLfT73c+gUFoptXrn7TiIPnt
         NvUnA4NRXrITj4jwAU82CDjQeWyxJVeK8anbZE2ivzMwTAQiru+GU6RHrrv4+z7ZBaes
         bxQg==
X-Gm-Message-State: AO0yUKWRp7gU65P0PH8Wz9kY2Wbny8faGzditPe5pawpUdURmbZh78lB
	hQ9DGLyAGoGwpd5bSK/Qx+97zBlkUbgn9nSiMH3ghg==
X-Google-Smtp-Source: AK7set8Gfoavx/5SCFT72EvQpyGbHidMzDJwPbirW66XrJirkHDkJTcACVpIH5e5LlQjObybnrdM2NGHuvBaDezUzvw=
X-Received: by 2002:a05:600c:c8:b0:3df:f29c:ec3a with SMTP id
 u8-20020a05600c00c800b003dff29cec3amr969617wmm.38.1676048327368; Fri, 10 Feb
 2023 08:58:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230126204444.2204061-1-zalbassam@google.com> <86fsbgyutf.wl-maz@kernel.org>
In-Reply-To: <86fsbgyutf.wl-maz@kernel.org>
From: Zaid Al-Bassam <zalbassam@google.com>
Date: Fri, 10 Feb 2023 11:58:36 -0500
Message-ID: <CALBRaFmj4Nvr=bjti+yCrRhtX61_aJhiCRDfbMJPLDhqVW8u1A@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: arm: Make PMUv3 driver available for aarch32
To: Marc Zyngier <maz@kernel.org>
Cc: Jesus Sanchez-Palencia <jesussanp@google.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"

Thank you Marc for reviewing the change and fixing the issues, I have
picked up your patches and sent out v2. Tested on Cortex-A32.

Best Regards,
Zaid Al-Bassam


On Wed, Feb 8, 2023 at 11:40 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 26 Jan 2023 20:44:36 +0000,
> Zaid Al-Bassam <zalbassam@google.com> wrote:
> >
> > Currently, PMUv3 driver is only available for ARMv8 aarch64
> > platforms, ARMv8 running in aarch32 mode dont have access to
> > the driver. This is, especially, a problem for ARMv8 platforms
> > that only have aarch32 support, like the Cortex-A32.
>
> FWIW, I've pushed out my own interpretation of this series to [1],
> including the changes I suggested. The results seems to correctly work
> in a 32bit guest on a 64bit host, which is what I (used to) care
> about.
>
> Feel free to pick it up.
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=arm/pmuv3
>
> --
> Without deviation from the norm, progress is not possible.
