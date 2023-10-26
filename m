Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8002EAFE
	for <kvmarm@lists.linux.dev>; Thu, 26 Oct 2023 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QUiTWacQ"
Date: Thu, 26 Oct 2023 16:31:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698330715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gh7Nm0UGIYs2Q8uUHR8BFDAb62odHkmv2yrJIpflUV0=;
	b=QUiTWacQROpYXmCoa3ssdOwVvOFGIgmwBFTkVwsoTeX6kznf/yUr1mRd2qbUTYjg/9aeSJ
	ingMHh/Gw63lVU7blXThPDX2kGobUWAbGRx61JqSa4eXj6CVC00dAEy7OMDUMXtgZNRJda
	wFVS95jeY0qKFKUmayhl3Qug1YMGm2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Matthias Rosenfelder <matthias.rosenfelder@nio.io>
Cc: Andrew Jones <ajones@ventanamicro.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Message-ID: <20231026-82e0400727da79cc04a637a4@orel>
References: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
 <20231024-9418f5e7b9e014986bdd4b58@orel>
 <FRYP281MB3146C5D86DCCBBB6CA37D3ACF2DDA@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FRYP281MB3146C5D86DCCBBB6CA37D3ACF2DDA@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 26, 2023 at 02:24:07PM +0000, Matthias Rosenfelder wrote:
> Hi drew,
> 
> thanks for coming back to me. I tried using "git-send-email" but was struggling with the SMTP configuration of my company (Microsoft Outlook online account...). So far I've not found a way to authenticate with SMTP, so I was unfortunately unable to send the patch (with improved rationale, as requested).
> 
> Since giving back to the open source community is more of a personal wish and is not required by management (but also not forbidden), it has low priority and I already spent some time on this. I will send patches in the future from my personal email account.
> 
> I am totally fine with someone else submitting the patch.
> If it's not too inconvenient, could you please add a "reported-by" to the patch? (No problem if not)
> Thank you.

You have the authorship

https://gitlab.com/jones-drew/kvm-unit-tests/-/commit/52d963e95aa2fa3ce4faa9557cb99c002b177ec7

Thanks,
drew

> 
> Best Regards,
> 
> Matthias
> 
> ________________________________________
> From: Andrew Jones <ajones@ventanamicro.com>
> Sent: Tuesday, October 24, 2023 13:31
> To: Matthias Rosenfelder
> Cc: kvm@vger.kernel.org; Andrew Jones; Alexandru Elisei; Eric Auger; kvmarm@lists.linux.dev
> Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
> 
> CAUTION! External Email. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> On Fri, Sep 29, 2023 at 09:19:37PM +0000, Matthias Rosenfelder wrote:
> > Hello,
> >
> > I think one of the test conditions for the KVM PMU unit test "basic_event_count" is not strong enough. It only checks whether an overflow occurred for counter #0, but it should also check that none happened for the other counter(s):
> >
> > report(read_sysreg(pmovsclr_el0) & 0x1,
> >       "check overflow happened on #0 only");
> >
> > This should be "==" instead of "&".
> >
> > Note that this test uses one more counter (#1), which must not overflow. This should also be checked, even though this would be visible through the "report_info()" a few lines above. But the latter does not mark the test failing - it is purely informational, so any test automation will not notice.
> >
> >
> > I apologize in advance if my email program at work messes up any formatting. Please let me know and I will try to reconfigure and resend if necessary. Thank you.
> 
> Hey Matthias,
> 
> We let you know the formatting was wrong, but we haven't yet received a
> resend. But, since Eric already reviewed it, I've gone ahead and applied
> it to arm/queue with this fixes tag
> 
> Fixes: 4ce2a8045624 ("arm: pmu: Basic event counter Tests")
> 
> drew
> [Banner]<http://www.nio.io>
> This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. You may NOT use, disclose, copy or disseminate this information. If you have received this email in error, please notify the sender and destroy all copies of the original message and all attachments. Please note that any views or opinions presented in this email are solely those of the author and do not necessarily represent those of the company. Finally, the recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.
