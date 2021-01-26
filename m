Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007C3C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 09:56:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B3B92072C
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 09:56:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B3B92072C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6744B1E6;
	Wed, 27 Jan 2021 04:56:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@mg.codeaurora.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bDCM9YKReyZT; Wed, 27 Jan 2021 04:56:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 807C44B1DC;
	Wed, 27 Jan 2021 04:56:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A776E4B179
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 15:31:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aJLT94Ke+QSr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 15:31:09 -0500 (EST)
Received: from m42-8.mailgun.net (m42-8.mailgun.net [69.72.42.8])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33DD44B170
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 15:31:09 -0500 (EST)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org;
 q=dns/txt; 
 s=smtp; t=1611693069; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=3tzwSCJKiPhnGKVQZS0Wr8QjsKWCsKhgKn+r0/Rsax4=;
 b=bnUb9Pr3OWxcqR7JMqyWVbroD1yBWgUjX8Y87zs1LxR6NgzN+0LJlLNkEzpM7DlhhAWmfPoN
 uDVnRo6jgLpdysw169ZTb/2XdlccNgDCajhxUrmdTd66WruHEOQPNpmuaoBwkkiA0OnHsSUK
 q01qWpG5wqWO9eR9qX/clpkF+IQ=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiM2ZhNCIsICJrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1IiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60107c0b5677aca7bd06c9bc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Jan 2021 20:31:07
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
 id 9021FC433ED; Tue, 26 Jan 2021 20:31:07 +0000 (UTC)
Received: from [192.168.1.11] (cpe-70-95-74-122.san.res.rr.com [70.95.74.122])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
 bits)) (No client certificate requested)
 (Authenticated sender: sramana)
 by smtp.codeaurora.org (Postfix) with ESMTPSA id 729B0C43469;
 Tue, 26 Jan 2021 20:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 729B0C43469
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org;
 dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org;
 spf=fail smtp.mailfrom=sramana@codeaurora.org
Subject: Re: [PATCH v4 21/21] arm64: cpufeatures: Allow disabling of Pointer
 Auth from the command-line
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-22-maz@kernel.org>
 <YAwydxY68TULznr1@Catalins-MacBook-Air.local>
From: Srinivas Ramana <sramana@codeaurora.org>
Message-ID: <accc21e9-f987-7244-b10a-a01842a3da3c@codeaurora.org>
Date: Tue, 26 Jan 2021 12:30:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAwydxY68TULznr1@Catalins-MacBook-Air.local>
Content-Language: en-US
X-Mailman-Approved-At: Wed, 27 Jan 2021 04:56:41 -0500
Cc: Prasad Sodagudi <psodagud@codeaurora.org>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

Hi Marc,

On 1/23/2021 6:28 AM, Catalin Marinas wrote:
> On Mon, Jan 18, 2021 at 09:45:33AM +0000, Marc Zyngier wrote:
>> In order to be able to disable Pointer Authentication  at runtime,
>> whether it is for testing purposes, or to work around HW issues,
>> let's add support for overriding the ID_AA64ISAR1_EL1.{GPI,GPA,API,APA}
>> fields.
>>
>> This is further mapped on the arm64.nopauth command-line alias.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Verified this Series for PAC control feature from command line. with 
arm64.nopauth, we could see PAUTH is disabled on both primary and 
secondary cores as expected.

HWCAPs show no PAC support and kernel instructions are being treated as 
NOPs.

Tested-by: Srinivas Ramana <sramana@codeaurora.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
