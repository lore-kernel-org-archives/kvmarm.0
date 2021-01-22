Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CBFC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 11:48:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B4DA235F9
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 11:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B4DA235F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 432284B19A;
	Fri, 22 Jan 2021 06:48:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gRHNyIxR9iwd; Fri, 22 Jan 2021 06:47:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E124B0F0;
	Fri, 22 Jan 2021 06:47:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8264B0F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 06:47:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R-K0lUIraT5M for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 06:47:55 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83EB84B0EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 06:47:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 321AE22CA1;
 Fri, 22 Jan 2021 11:47:54 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l2uuu-009P1V-1R; Fri, 22 Jan 2021 11:47:52 +0000
MIME-Version: 1.0
Date: Fri, 22 Jan 2021 11:47:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [RFC PATCH v4 0/2] Some optimization for stage-2 translation
In-Reply-To: <20210122101358.379956-1-wangyanan55@huawei.com>
References: <20210122101358.379956-1-wangyanan55@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <a6d4d16574fa76c4e519cdbff70cf950@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangyanan55@huawei.com, will@kernel.org,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, gshan@redhat.com,
 qperret@google.com, wanghaibin.wang@huawei.com, yezengruan@huawei.com,
 yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Yanan,

On 2021-01-22 10:13, Yanan Wang wrote:
> Hi, Will, Marc,
> Is there any further comment on the v3 series I post previously?

None, I was planning to queue them for 5.12 over the weekend.

> If they are not fine to you, then I think maybe we should just turn
> back to the original solution in v1, where I suggestted to filter out
> the case of only updating access permissions in the map handler and
> handle it right there.
> 
> Here are the reasons for my current opinion:
> With an errno returned from the map handler for this single case, there
> will be one more vcpu exit from guest and we also have to consider the
> spurious dirty pages. Besides, it seems that the EAGAIN errno has been
> chosen specially for this case and can not be used elsewhere for other
> reasons, as we will change this errno to zero at the end of the 
> function.
> 
> The v1 solution looks like more concise at last, so I refine the diff
> and post the v4 with two patches here, just for a contrast.
> 
> Which solution will you prefer now? Could you please let me know.

I'm still very much opposed to mixing mapping and permission changes.
How bad is the spurious return to a vcpu?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
