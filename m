Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23C746AB
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 06:14:41 +0000 (UTC)
Date: Tue, 3 Oct 2023 08:14:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696313679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lhrbswG2p44Bvv455TmMlICJyrlE01TZRslI5wXx10=;
	b=ekgM54Qrfuvjj7vsrGrMAfdsruoRW/pxLqw7eRos/9dA5jKx740HrExryKIJ3y7FvA3yn0
	QDhWiZl6DqXMQZJrlC87V60liFuJ82Ru2iUtVjY2DOmHO3kXy4l+9+ycn0tuux9tomQ23Z
	MQ4XX9hI81VtC/0XFg9M0BM848dVWl0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Matthias Rosenfelder <matthias.rosenfelder@nio.io>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Message-ID: <20231003-e7e54e0ce6d7cfe167a73df4@orel>
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
X-Migadu-Flow: FLOW_OUT

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

Hi Matthias,

Your mail client sent the patch as an attachment. Please use
get-send-email to submit patches and put the justifications for the
patches, like you've written above, in the commit messages.

Thanks,
drew

> 
> Best Regards,
> 
> Matthias
> [Banner]<http://www.nio.io>
> This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. You may NOT use, disclose, copy or disseminate this information. If you have received this email in error, please notify the sender and destroy all copies of the original message and all attachments. Please note that any views or opinions presented in this email are solely those of the author and do not necessarily represent those of the company. Finally, the recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.


