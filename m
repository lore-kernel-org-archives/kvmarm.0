Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2A0D2ED
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 16:45:09 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id k2so16650337pll.8
        for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 09:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679417109;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PlarJ0OGF8pkEDqeJJSsl/9GBmK/xQa68WOfjnTxTjk=;
        b=k2dHWrk4ZA7dyNnN5vp5tHWFuDNVcxzxToAO3J3ugpvZ0E10NmX+QZnq/zOW2tl+I/
         MBMxavAdD9q8L85YzDAE1zObQtM56Zb1YSFKZmFBP6zRk19ym9kC5GvAsprt7ItIWAG/
         P1U1KRitFyZl/acODJBOFxejxZCh9VcyqbL5Sf5Hxj0mETFG43mU9XTn36/B9NAIC8p5
         sIPbGfdexpXAxLTKI6w2sStgztHlhV4+3gGO28i/yWLOpSrNuTiiJHahoVgzZLGBQrv5
         ddU/Q7PwFbbXom3XSsaX+NOjIeFHnNylPhEdIxYElbjGwQqBuh32gLChhxwYEcUA/FGE
         wUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417109;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlarJ0OGF8pkEDqeJJSsl/9GBmK/xQa68WOfjnTxTjk=;
        b=NJ4zn6N47S/MxF5zb/TX5/cs9P8z9BUqqOM6BNToXI0cz3457FJWor6CrOCQdts+1P
         m9royUIGB+i9gKiIMska5j7VX2aQ5mucUzfNk9l4GjLrjsHpyByRfesCphEEcMm6GNme
         DM2cjDCxum54fuyiCNxpejh6TNCKEB9cGx8lmBi7otsDAs3TKTzy4CTOv4t8NYCrFy4M
         eEWYvZWMddhzM3T0IDT2Mycl9KG1iU+oKbhnWOLhBwKTduJrZoru8IplIyU0gMeWZNV+
         k2xv3CixYuEwPNgXrnN2yKsPdgX8ybpRi9xfG+SpoLpkgoMvB++FjJFAOABDDF1e9HjM
         ZjeQ==
X-Gm-Message-State: AO0yUKUgKiwDopBUFeoJbPhl1TYkfi34v1zWhZYZgP9pPds6ipHs9B1T
	pLoUMSAt+H/vGfVcF1Ju/3k=
X-Google-Smtp-Source: AK7set/0xYNfpLT23Vcb8VnUON0ApbKO9wIPEff4ECW/aMWqnvsEFwzc7VGHpqSz8WKyA4OyIMzJAw==
X-Received: by 2002:a17:90b:4b07:b0:234:889f:c35d with SMTP id lx7-20020a17090b4b0700b00234889fc35dmr606544pjb.3.1679417109058;
        Tue, 21 Mar 2023 09:45:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc2-20020a17090b3b8200b00229b00cc8desm3475194pjb.0.2023.03.21.09.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 09:45:08 -0700 (PDT)
Message-ID: <6f57ea15-08bf-38f3-5065-b3c5fe4863d0@gmail.com>
Date: Tue, 21 Mar 2023 09:44:57 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 0/8] perf: arm: Make PMUv3 driver available for aarch32
Content-Language: en-US
To: Zaid Al-Bassam <zalbassam@google.com>,
 Jesus Sanchez-Palencia <jesussanp@google.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
References: <20230317195027.3746949-1-zalbassam@google.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230317195027.3746949-1-zalbassam@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/23 12:50, Zaid Al-Bassam wrote:
> Currently, PMUv3 driver is only available for ARMv8 aarch64 platforms,
> ARMv8 platorms running in aarch32 mode dont have access to the driver.
> This is, especially, a problem for ARMv8 platforms that only have
> aarch32 support, like the Cortex-A32.
> 
> Make the PMUv3 driver available to arm arch (ARMv8 aarch32) by moving
> the PMUv3 driver from arm64 to drivers, that makes the driver common
> to both arm and arm64 architectures, then add PMUv3 arm Support.
> 
> The main work in this patchset was made a while back by Marc Zyngier
> in [1]. Patchset version 1 [v1] rebases Marc's patches to the latest
> kernel revision and adds additional patches to accommodate the changes
> in the kernel since Marc wrote the patches.
> 
> version 2 [v2] of the patchset was created by Marc Zyngier and I
> picked it up from [2].
> 
> Changes in v2:
> - Flattened the nested switches in the arm_pmuv3.h for arm.
> - Removed wrappers and added stubs for the PMU KVM functions for arm.
> - Added PMU version abstractions.
> 
> Changes in v3:
> - Removed the link tag from the commit messages.
> - Fixed the license header in the arm_pmuv3.h files.
> 
> Changes in v4:
> - Rebased to 6.3.0-rc2 (Clean rebase)
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm/pmuv3-32bit
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=arm/pmuv3
> 
> [v1] https://lore.kernel.org/all/20230126204444.2204061-1-zalbassam@google.com/
> [v2] https://lore.kernel.org/all/20230210165500.2292608-1-zalbassam@google.com/
> [v3] https://lore.kernel.org/all/20230213210319.1075872-1-zalbassam@google.com/
> 
> Thank you,
> Zaid Al-Bassam

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

on Cortex-A53 and Cortex-A72, thanks!
-- 
Florian

