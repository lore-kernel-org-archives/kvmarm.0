Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDA114F74
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 11:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="P4pga1sa"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-507bd64814fso6351390e87.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 04:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698147103; x=1698751903; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BYH227TNmETvLgiFYzkkeDFOa5cAeGRjW0q0lGDqvfQ=;
        b=P4pga1sabiTYRpKtyTKQ6FTgDbag+a3ydwWp9eOiVeJm84p1HuOHhFeStJY+4WoQZ0
         4cHGF7HtdNi0UGDQ8T/tYtb9dSQNap2pV7o8A2I6hnGdsVaPGotOHw+wC5x/e8TdtBfz
         nN67+Q1Qt+N/79dcoLQA23yZy5Y6rshCoauHlbCywcpFG5RlL9acfInkDnfpd7+sGBh0
         3PnGJUppolvBvM+xwAVODcY01uyCaZL9b4L9BLHa01Tg0IE5SadrCFvEVYNNczKyUTxC
         I3L/f6NGLBKtx2MI5NUZKgdqPBxTrISQeS2y415CTj9guFpzkluRVFUNax8xN4EoI8Ff
         kkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698147103; x=1698751903;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BYH227TNmETvLgiFYzkkeDFOa5cAeGRjW0q0lGDqvfQ=;
        b=fjnA1MI8X0pbTTK6tVNBcrHWlK18rdEBypgn81HKQymmCj8aJaAOvaOfoS6z4mw4HM
         zmuAM7+1tK+DeyX8wOF4OeBOi9+zPIEoS1wbX8I/EPCW7Vq43zYdgim/omupS+He61KN
         MdhnuwAkz5XqgP1BCDo1OegE5lQSVK4WF9Db2pbTZmpmSq/dlS1RKwbrwtPkhZPYD6P8
         shDW3L4pyuPDwpL1P8Jy3RPQyY9KnteOWe0ip0DPlwSltPBDAsspCg2gbU1WqjiV4cN9
         u/asaTF0vqDzS9RSmvhl1rZBYma+dOkPWxFEzHDrPrvSbl+JrNALasLTiCrisWPOqWqX
         hCoQ==
X-Gm-Message-State: AOJu0YwKt+HsvNFfyq5CoX4DQpyDOAEWu4yPXI5SQO6ZgK52C/5Z6z0a
	FJ7SztBRrZEmyh/h7vvsoLF7uQ==
X-Google-Smtp-Source: AGHT+IFeJyUG+BU9vPz+IRDCZmjWiKngbqDyjvsC5ZvlsbdlYH+ryb1lqbxUSUqD1xb8tTeqWFPocA==
X-Received: by 2002:a05:6512:4db:b0:507:a671:3231 with SMTP id w27-20020a05651204db00b00507a6713231mr7925311lfq.52.1698147102559;
        Tue, 24 Oct 2023 04:31:42 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id a3-20020a5d4d43000000b003196b1bb528sm9700676wru.64.2023.10.24.04.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 04:31:42 -0700 (PDT)
Date: Tue, 24 Oct 2023 13:31:41 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Matthias Rosenfelder <matthias.rosenfelder@nio.io>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Message-ID: <20231024-9418f5e7b9e014986bdd4b58@orel>
References: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>

On Fri, Sep 29, 2023 at 09:19:37PM +0000, Matthias Rosenfelder wrote:
> Hello,
> 
> I think one of the test conditions for the KVM PMU unit test "basic_event_count" is not strong enough. It only checks whether an overflow occurred for counter #0, but it should also check that none happened for the other counter(s):
> 
> report(read_sysreg(pmovsclr_el0) & 0x1,
>       "check overflow happened on #0 only");
> 
> This should be "==" instead of "&".
> 
> Note that this test uses one more counter (#1), which must not overflow. This should also be checked, even though this would be visible through the "report_info()" a few lines above. But the latter does not mark the test failing - it is purely informational, so any test automation will not notice.
> 
> 
> I apologize in advance if my email program at work messes up any formatting. Please let me know and I will try to reconfigure and resend if necessary. Thank you.

Hey Matthias,

We let you know the formatting was wrong, but we haven't yet received a
resend. But, since Eric already reviewed it, I've gone ahead and applied
it to arm/queue with this fixes tag

Fixes: 4ce2a8045624 ("arm: pmu: Basic event counter Tests")

drew
