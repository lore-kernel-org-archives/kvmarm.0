Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E165C4361B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 20:13:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0640123BEF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 20:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0640123BEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27CF14B18C;
	Wed,  9 Dec 2020 15:13:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EKii5SzDfE6H; Wed,  9 Dec 2020 15:13:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 240284B192;
	Wed,  9 Dec 2020 15:13:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DED3A4B18C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 15:13:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAyXi4K-3ZgV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 15:13:10 -0500 (EST)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD2BA4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 15:13:10 -0500 (EST)
Received: by mail-ot1-f66.google.com with SMTP id o11so2663072ote.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 12:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=e8PjCwF/fkBvctzYsKsZigRs7c0yUbgHiIHG6Juga9s=;
 b=BIV963S9gDvXeQAOzns5FeH54xHaZsWE2jkhvfcqjhTbpeqeT0estcM/IfKJmSSHH+
 jkh57TwvgmRVvfxB+Qo71cAE0xrZYMHfkKuyI64hd1XQdnL6GMJZlsO2xpbIJrcTcX9V
 vKHcJUdwk3WKtQciMOSuTQh5G++HPfT/Joq8LGH4unQwsOxA44wujOoCBlvODbfuPGzg
 el+3ulvnUXnUhmFx+pSJBMi+fGpeU+1aEjt7cOgXEdndQM3eISMcRGcodf14HUz4jTJo
 bYRVTqY7o9uYWxwgrlTFgr47ReMJfvbUmzJ/WQpWW6Ri+wy8gteEDbtHpTLzD9lngSKX
 RzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=e8PjCwF/fkBvctzYsKsZigRs7c0yUbgHiIHG6Juga9s=;
 b=Eh4tsZCedH+Ay5AgwAmg9AHRgET0Mc16O7m5h0vUxEJEa81cyZzNM8SVtfgPvqWjEg
 ExtRzTzojf7NpKIRcxBNTQqBrdOg6D/831yeuZhgng0yfNBmgZLwgJEzpIPrgU/uv6w/
 /ncar2dPmB3g+J9z2bfv9lPeVlpFxVZX7dGH/Dv1S5ZCHmIHv+a/QT/TGwd483G9hvno
 eckGH1n/NXhCmcv/2IkTJE4qfaO6ihp95I8kLpZavVfEl4xBErOhERXiTwvgOGutyGTA
 nct0mXhjsu+s9bWog4fyQbbWfXu5O/QMEE2qfk/RzpYeypE8mjjn9K8cReEh1sHPf/qN
 5UpA==
X-Gm-Message-State: AOAM530TXMwz7WiQ4gmVn7PZO9nzNCeYPsp0DlB7W+brkVawilkKLf4v
 aU8mvJ767kfaXdNfJDYI380eOw==
X-Google-Smtp-Source: ABdhPJymjhe79Shp+3MxdinfT87wlVy927PQ3peJTbXAMIVFHAHI6bhArk4K6dMUycTMNOoArAw/Kw==
X-Received: by 2002:a05:6830:1ae4:: with SMTP id
 c4mr2163447otd.295.1607544790091; 
 Wed, 09 Dec 2020 12:13:10 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net.
 [187.189.51.144])
 by smtp.gmail.com with ESMTPSA id l1sm522451ooi.48.2020.12.09.12.13.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 12:13:09 -0800 (PST)
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Catalin Marinas <catalin.marinas@arm.com>
References: <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com>
 <0d0eb6da6a11f76d10e532c157181985@kernel.org> <20201207163405.GD1526@gaia>
 <874kkx5thq.wl-maz@kernel.org> <20201208172143.GB13960@gaia>
 <7ff14490e253878d0735633b792e1ea9@kernel.org> <20201209124443.GB13566@gaia>
 <ef14a5158fc65c00f6c3c842cfa83b2c@kernel.org> <20201209152741.GC13566@gaia>
 <8c39b104-39c3-7cca-82b9-2e47d7cb9a9a@linaro.org>
 <20201209183920.GI13566@gaia>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <6b9072fb-1232-e9fb-0b97-e69709980f99@linaro.org>
Date: Wed, 9 Dec 2020 14:13:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201209183920.GI13566@gaia>
Content-Language: en-US
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>, Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On 12/9/20 12:39 PM, Catalin Marinas wrote:
>> I would have thought that the best way is to use TCO, so that we don't have to
>> have dual mappings (and however many MB of extra page tables that might imply).
> 
> The problem appears when the VMM wants to use MTE itself (e.g. linked
> against an MTE-aware glibc), toggling TCO is no longer generic enough,
> especially when it comes to device emulation.

But we do know exactly when we're manipulating guest memory -- we have special
routines for that.  So the special routines gain a toggle of TCO around the
exact guest memory manipulation, not a blanket disable of MTE across large
swaths of QEMU.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
