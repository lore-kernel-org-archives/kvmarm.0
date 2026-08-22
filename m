Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC092AD00
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 17:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787421510; cv=pass; b=F+5KmmrGqTzwn2z/q8WfcarUIQ+wdJY0lApcTn1v0V1We8QO2xm+FAD0hSxE5e1PK6L+HcHCrYdS3Mw0A1KXS68Jr/xCMbnV0LAOiSQk4efM1Pmx/FEuCXJ6WhWxM4x2qfkAc6tTU9tacOnh34yAxdjSD7bD2iH2p3qaU91MYMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787421510; c=relaxed/simple;
	bh=5uVSKut5uWA+O/bl1lu8n1UjU2a74/+vL2uiZFUMZuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tZ7V8rV7/cEXAeBJs3JVvtxbgXR0kicjH+t5oJCdCMcSaeHk9TqhuazrywkyGt0d+votobux9h1dcXrM8Lo+3C7yyZJPgt4p1OR0RSGnhWmiQN699EuUpEnlMLfk0UhSxeaMiPcFoS3PRmWryo6EoGCSeTJKueYsGZPdvN2czaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C0zxgEU8; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C0zxgEU8"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso33525e9.0
        for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 10:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787421507; cv=none;
        d=google.com; s=arc-20260327;
        b=FhXKamKluib9Juy2ead6dXyUCJgRgBpMTGVfHf4aNhCZ7pYm0bmU8O6pPDMUsBWRRV
         IgFhPnTwsqrOMEdqLb7eJpO2pLEGfPhMP8msv024Ug81FPB7KvQqZVT90jfta5M32pb5
         xNFFRYgWVZSUx/LUkT5edwUhohGcxQXmXJDM9NHQtAEvqldLnUa1nzrZNHW3QzaLK2J9
         qujnBTLJYmQXHX2x5HsoOEx1WDI8xFJcUvzhYtuE/F14MBUpn0gMfOm+D5RczTkxh/o3
         y3wGc+Mk29ibYhwxFtMXFePep9e5effnXDyr/gzRUYaHSK4iVYmRS25XP8Sqwet870Ac
         wZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4zS3gK3kbG0uK+a0zea0r7Wu/L46iQSxpvjeCO3tlVk=;
        fh=/kwIcTipahPBWVFD6hzaG+uVTzf8pkyXs0HJ8dOc8ak=;
        b=Ow62SASeKof4u+M3fZv4KYz9oKcMuIXWCLMZen+hoe9u4Bj+i2YLesh8wiWSm0GQUN
         uvnEyLVcXFseakvA5W4AIPrdIr8yScDNenyy2ZAdSg0JpHAE1H4Mviak8ec253+x23tO
         mSqOGIsRYBXS8iGiMB5AuNgDJKemm0lHF3nwPx4JoU6DGC0tQP2MSP7Eej7mRTK0KGfN
         nl23Sz95AFg52bmrGf2a+eE9cUvLg1vU0YDQrhAWDbd3g69sijxtFqYJ8qwKVlPii4Fh
         4/ElQ+7MmHBi8tQJC2mt7SakQ98/K5l1XNjfdfJhhJ1yHRbwjNK6G3albpo4BYT7/rWb
         QzEw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787421507; x=1788026307; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4zS3gK3kbG0uK+a0zea0r7Wu/L46iQSxpvjeCO3tlVk=;
        b=C0zxgEU8pzq8f0uJyoFfMLsJPk2WpxKpelmOOhgA708HOft3pKZgBy2VzjpDS00BMD
         Dgk1ZMt6Vkb9cPDRTgGIZSByAsFoBtOTvP+thmvAR6GsRsOmcr3Q/BVOp4m6/GTijxJv
         3pzGgNmUkDD8344A/LT4wA/QurnLs7d7KEdnvnOJJ6QRMhVYrP1PooDGPT9ohyAom7WY
         kKPyToWBINBeSDozsvhy21HAchxCJPHP59nYL2byXAuTJOPCkACWMA2FwbF37N1+zeVX
         LglrO8aGQE3HVv+ba2Tp4NUb3EpkcTbanOtfxdehJ7wFAUET37mL7qZGQfo1T7Rhze0F
         Etpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787421507; x=1788026307;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4zS3gK3kbG0uK+a0zea0r7Wu/L46iQSxpvjeCO3tlVk=;
        b=dgXCw9/rGtNrlNQrfg1nZchs1ag/vdQzmMyddK2W3VzMqouK7EtZ7mp5YLGi9xzoaK
         kxrW8TljPHDllJoivLWo90SQwwpecnfwrq6l9pPSZJSRq4KxCpjz+Gum4gf9Wu24HdjY
         pG886yJXUg48kttbrzcaTGtfH2nrq7obRkDs/hNOIA4A4PGHitXDX++egcdgeYlbarpd
         Th/aAgUX2czjHdd3PDKXSOq+3bkJteRAkvu528Xzr7+9zEgoOLsLwWOV6PH7s17yGKIY
         MThY4hnbVnpS4VLLy2lIb99fLMwl58h78q+k1ZYJC6ij7ynNF7gsuRyP1UgWaGGT7qGu
         4owQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTHSbMhBYjqPwaORh7wCjHiO9COB/dYAXCPUjw9t7pDBwvBbDJG/TdcUDNqElk2H42edBYlCg=@lists.linux.dev
X-Gm-Message-State: AFuF++nx+AlnJvClWnHinmBGiK+w8NRX9rkRMwIjB/aOUlMsVaHJH9jH
	MRj6+lNuZ0LPRp+o6xkqKU7+/OEonGBtIsoDL0SVGqjhFnAh8sjDZnRKZiJqrOZcB8w3ZDsY9L+
	Cuf/EgY7hlyLxfjTaRTephtWqf8psj6g/S/q9IwXI
X-Gm-Gg: AR+sD10EACHbu4HeofGgz5TfmbBNz5EX6g8UVyBgQvtKJCQJ6+pb+oYvIyWmNNXYvLu
	55KSFA7zj6yNzJ7soVlfJcmtWK8H3h6DQxQusXddedbBH9pLkMghL+QV0PPNkupnVX9bMUfB2fn
	LIi5bqFkZlfu7fcip+3Q0VUMMLxndZWHB4cRsQBhFQmE0FCF0eeamzHbPZBpYngbNHTWi6cDWzi
	ODs55MAIJyhnm4AvuoNt9rm5xIHRAM0kKorsE50UoVV7PbUr6aD+vNm6zcInWbknvOu/yWvK+lq
	FMZzUpRxUNr2k9pk0Im/1YXIj17ZzmGBbeBKzzlbLMMxRQ4fAlLooBrIr0ZA7o8OXhg5dpYuw48
	E
X-Received: by 2002:a05:600d:8497:10b0:493:b47f:a24 with SMTP id
 5b1f17b1804b1-499c1af1896mr748535e9.6.1787421506423; Sat, 22 Aug 2026
 10:58:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260818112920.26252-1-likexu@tencent.com>
In-Reply-To: <20260818112920.26252-1-likexu@tencent.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sat, 22 Aug 2026 10:58:13 -0700
X-Gm-Features: AcwNN1X_VXIwrCLgCNcnCbYWNahBq__ZqtblvwVpucn-WDdeu9vmJJAyLXBZxPM
Message-ID: <CACw3F52CfURHgdAhwQFXagGhijPZY4v1Njg709uHVf-20wRWOg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: selftests: arm64: Make sea_to_user skip cleanly
To: Like Xu <like.xu.linux@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 4:29=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> This series hardens the arm64 sea_to_user selftest so that it reports a
> clean skip on hosts that cannot actually run it, instead of aborting or
> silently passing.
>
> The test drives a real recoverable memory UER through APEI EINJ and
> expects the guest to consume the poison and exit to userspace with
> KVM_EXIT_ARM_SEA. That relies on host and firmware support that is not
> present everywhere, and each unmet dependency is now turned into a skip:
>
>   - EINJ injection is driven directly through debugfs, and an unusable
>     EINJ (not built, no firmware support, or not running as root) is
>     classified from errno and skipped rather than mishandled.
>   - Guest memory is backed by 1GB hugepages; with an empty pool the test
>     now skips up front instead of failing an mmap() with -ENOMEM.
>   - Some firmware only arms EINJ poison as part of the trigger step that
>     notrigger=3D1 skips, so nothing consumable is left for the guest to
>     read. That case is detected and skipped rather than reported as a
>     spurious KVM_EXIT_MMIO failure.

Thanks for these fixes. Just wonder, do you mind also integrating two
previous fix attempts in [*] into this series:
1. Refactor run_vm to catch GUEST_FAIL, instead of causing confusing
unhandled MMIO kvm exit.
2. Sync far_invalid to guest.

, given the high level goal is to harden sea_to_user.c?

The first one will make the test result less confusing for the runner.
The 2nd one improves readability. You can re-use my code in the patch.

[*] https://lore.kernel.org/kvmarm/20260130192837.890688-1-jiaqiyan@google.=
com

>
> Tested on an arm64 host with CONFIG_ACPI_APEI_EINJ: on a platform whose
> firmware places no consumable poison under notrigger=3D1 the test now
> skips cleanly, and the earlier -ENOMEM and abort paths are gone.
>
> v1 [1] was a single patch doing only the 1GB hugepage check. Following
> Marc's review [2], it is expanded into a series that also fixes the EINJ
> handling the test depends on.
>
> Test Results:
>
>   Case 1 (echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepa=
ges):
>
>   # timeout set to 120
>   # selftests: kvm: sea_to_user
>   # Random seed: 0x6b8b4567
>   # 1..0 # SKIP - Requirement not met: get_free_hugepages(backing_page_si=
ze) >=3D VM_MEM_SIZE
>   ok 1 selftests: kvm: sea_to_user # SKIP
>   # 1 skipped test(s) detected.  Consider enabling relevant config option=
s to improve coverage.
>   # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
>
>   Case 2 (rmmod einj):
>
>   # selftests: kvm: sea_to_user
>   # Random seed: 0x6b8b4567
>   # # Mapped 0x40000 pages: gva=3D0x80000000 to gpa=3D0xff80000000
>   # # Before EINJect: data=3D0xbaadcafe
>   # # EINJ_GVA=3D0x81234bad, einj_gpa=3D0xff81234bad, einj_hva=3D0xffff41=
234bad, einj_hpa=3D0x42c1234bad
>   # 1..0 # SKIP need CONFIG_ACPI_APEI_EINJ and firmware EINJ support
>   ok 1 selftests: kvm: sea_to_user # SKIP
>   # 1 skipped test(s) detected.  Consider enabling relevant config option=
s to improve coverage.
>   # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
>
>   Case 3 (modprobe einj):
>
>   # selftests: kvm: sea_to_user
>   # Random seed: 0x6b8b4567
>   # # Mapped 0x40000 pages: gva=3D0x80000000 to gpa=3D0xff80000000
>   # # Before EINJect: data=3D0xbaadcafe
>   # # EINJ_GVA=3D0x81234bad, einj_gpa=3D0xff81234bad, einj_hva=3D0xffff41=
234bad, einj_hpa=3D0x42c1234bad
>   # # 0x10 > /sys/kernel/debug/apei/einj/error_type - done
>   # # 0x2 > /sys/kernel/debug/apei/einj/flags - done
>   # # 0x42c1234bad > /sys/kernel/debug/apei/einj/param1 - done
>   # # 0xffffffffffffffff > /sys/kernel/debug/apei/einj/param2 - done
>   # # 0x1 > /sys/kernel/debug/apei/einj/notrigger - done
>   # # 0x1 > /sys/kernel/debug/apei/einj/error_inject - done
>   # # Memory UER EINJected
>   # # SIGBUS (7) received, dumping siginfo...
>   # # si_signo=3D7, si_errno=3D0, si_code=3D128, si_addr=3D(nil)
>   # not ok 1 Exit with signal unhandled
>   ok 1 selftests: kvm: sea_to_user
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> Changes since v1:
>   - New patch 1: drive EINJ injection directly through debugfs with
>     open()/write() instead of access()+popen(). Classify the open()
>     errno so an unprivileged run skips as "requires root" instead of
>     falsely reporting missing firmware EINJ, and report a genuine write
>     failure instead of the ambiguous "Failed... Success (0)".
>   - New patch 3: detect when notrigger=3D1 leaves no consumable poison an=
d
>     skip cleanly, instead of exiting with a confusing KVM_EXIT_MMIO.
>   - Patch 2 is the original v1 change, unchanged.
>
> Not yet addressed from [2]: dropping the hard 1GB-hugepage and 4kB
> base-page requirements. Suggestions on an acceptable backing scheme are
> welcome.
>
> [1] https://lore.kernel.org/kvm/20260817080759.25601-1-likexu@tencent.com=
/
> [2] https://lore.kernel.org/all/86y0le9cvz.wl-maz@kernel.org/
>
> Like Xu (3):
>   KVM: selftests: arm64: Fix EINJ handling in sea_to_user
>   KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
>   KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison
>
>  .../testing/selftests/kvm/arm64/sea_to_user.c | 75 +++++++++++++++----
>  .../testing/selftests/kvm/include/test_util.h |  1 +
>  tools/testing/selftests/kvm/lib/test_util.c   | 15 ++++
>  3 files changed, 77 insertions(+), 14 deletions(-)
>
> --
> 2.50.1 (Apple Git-155)
>
