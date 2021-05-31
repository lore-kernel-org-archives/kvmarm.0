Return-Path: <SRS0=K5Hb=K2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F363C47080
	for <kvmarm@archiver.kernel.org>; Mon, 31 May 2021 11:14:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DD476135B
	for <kvmarm@archiver.kernel.org>; Mon, 31 May 2021 11:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DD476135B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA34C4018F;
	Mon, 31 May 2021 07:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2yH7+CPYyzPy; Mon, 31 May 2021 07:14:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1AC04066E;
	Mon, 31 May 2021 07:14:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ED8F4018F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 07:14:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIyumPgkHasi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 May 2021 07:14:04 -0400 (EDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 970D2400D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 07:14:04 -0400 (EDT)
Received: by mail-ej1-f54.google.com with SMTP id gb17so16104386ejc.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 04:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:from:date:message-id:subject:to:cc;
 bh=mHC6kg9c+4sLUzLIkVSoHdH42qTJPJ/8ZqONWvVOQN0=;
 b=z5yUUnRi/TBcBsaMjZNTifZJV+AgaBYq/soAnh2Q+oWuOqvte2/H1j8bHIPvOwehUe
 N89aOoo8EKBS9/WZJA+TQX0PKiFDQ1M7ybnP9ldNHmI0/ULlMWcCYNK9iEJoM9VshWbm
 GqpzSW7IcyFDTz2I84DP2du0oEeVXS1/4NUFsJHIQUvf4hp/lvO4NxXL87feLUQUNPiN
 KWev3s7XH9NfUXJp9YdTqV5VJXUz7ioI1sYZhiCi251lfqz6OO9rQqb31aWvwBWe/3M3
 ANgwsSWIsbJQdyr1q5LyJsgd7Am1fkhoGaW3C5+JCWZoGkGOhQApT+awZh1YXHFDgNGx
 YQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
 bh=mHC6kg9c+4sLUzLIkVSoHdH42qTJPJ/8ZqONWvVOQN0=;
 b=B4ZXVB4KiXeA8ss9c8o+ZIOiAC9BLDHyIcvCJSX9G6fJMawJuLRE2T0+hWV8zsK7J4
 ipEHiXRpYbdKM+hirK0KlG8ZcKKPIHKI5JOhz1hR8Ca5EqqYEaQbYB8UZ7eXrihTE6UV
 5+gjClsvku4/TWUOmBsBC2R4ae7N3t+a5o4Q0jp3yyMsWy1/Lx5qZFCTgYb/1t1zgLfj
 b+T4tv8K8f5pJOhL2MB/ds3Uz/xP7NUO0u8oJ3i1yta/lt2c7tS7CfuELo96MmvdIzgS
 Ji5MI5zKiej07D2krERjwetG0csHimrfPFODa9qlu5+pZ7GqZLbNrQDhfkLg9eXJCAQq
 CbCw==
X-Gm-Message-State: AOAM533/bDTZXPn3Zxufa3NXT1l8L1WqKe/fctI1bZpcSZctveHT+FMB
 XdpLPLX0978Kyk9j9AJ8+a4Ud+XtozEyMA4zsDtQPg==
X-Google-Smtp-Source: ABdhPJzXk8Lt3DpQOUGgad2UrC1f81NDzrAdSNkKHcfoTv1hmTY1uZJWL0xTaw63yS+39qpClAeAWEe88VN/O4pp3F8=
X-Received: by 2002:a17:906:8318:: with SMTP id
 j24mr3744182ejx.375.1622459643368; 
 Mon, 31 May 2021 04:14:03 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 31 May 2021 16:43:52 +0530
Message-ID: <CA+G9fYtwjDoDr=hrSGLg4x5pv3Kq-MbCTzohy3=yLLN7P-Czqw@mail.gmail.com>
Subject: [stable-rc] 5.12 arch/arm64/kvm/arm.c:722:8: error: use of undeclared
 label 'out'
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, linux-stable <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The Linux stable-rc 5.12 arm64 builds failed due to these warnings / errors.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
clang'
arch/arm64/kvm/arm.c:722:8: error: use of undeclared label 'out'
                goto out;
                     ^
arch/arm64/kvm/arm.c:918:1: warning: unused label 'out' [-Wunused-label]
out:
^~~~
1 warning and 1 error generated.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

step to reproduce:
------------------------

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm64 --toolchain gcc-9
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1tILLnkg7Rqf4tsdhjS3VoZDrdk/config

--
Linaro LKFT
https://lkft.linaro.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
