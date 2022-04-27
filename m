Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66651C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 14:51:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 029C54B284;
	Thu, 28 Apr 2022 10:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 03RicFzo9xsk; Thu, 28 Apr 2022 10:51:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE5C4B26C;
	Thu, 28 Apr 2022 10:51:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB8F4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 17:08:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-ifUVWq9ymS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 17:08:06 -0400 (EDT)
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3822A4B1B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 17:08:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1651093686; x=1682629686;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=72myrHNOElx0NFEdtvKq9LM47tdwhmLkiKszPoSGAUg=;
 b=FsUicBLT6rFFGVwFI6mYHp0OAEMcplCrnkYxMl8d37mG477zEXDAH6eV
 tZuDJRtuhGebCG6CcpF2i+idrbS4u6JoqR2k5Ehj9ssv6jts4sjYyiR4i
 W4zD1iGIy3ANcvwPj+b8nb31KHgoPIjhL4zA4gdhnlh0QbH8nG4crIoQO E=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
 by alexa-out.qualcomm.com with ESMTP; 27 Apr 2022 14:08:05 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Apr 2022 14:08:04 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 27 Apr 2022 14:08:04 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 14:08:02 -0700
Date: Wed, 27 Apr 2022 17:08:00 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
Message-ID: <20220427210800.GB2047@qian>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220427170858.GA2009@qian> <Yml599vM948wXt6g@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yml599vM948wXt6g@sirena.org.uk>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Thu, 28 Apr 2022 10:51:13 -0400
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah
 Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Luca Salabrino <luca.scalabrino@arm.com>
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

On Wed, Apr 27, 2022 at 06:14:31PM +0100, Mark Brown wrote:
> On Wed, Apr 27, 2022 at 01:08:58PM -0400, Qian Cai wrote:
> > On Tue, Apr 19, 2022 at 12:22:08PM +0100, Mark Brown wrote:
> 
> > > but not SVE, SME is an ARMv9 feature and SVE is mandatory for ARMv9.
> > > The code attempts to handle any such systems that are encountered but
> > > this hasn't been tested extensively.
> > 
> > Running CPU offline/online on a Neoverse-N1 server will trigger a crash.
> 
> Can you try with 
> 
>    https://lore.kernel.org/r/20220427130828.162615-1-broonie@kernel.org
> 
> please?

Yes, it works fine so far.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
