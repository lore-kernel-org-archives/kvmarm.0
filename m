Return-Path: <SRS0=LaKu=5Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E64C2BB55
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 07:39:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E75EC2082D
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 07:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=kolabnow.com header.i=@kolabnow.com header.b="hV2TUNwJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E75EC2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vaga.pv.it
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BBA94B196;
	Thu,  9 Apr 2020 03:39:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kolabnow.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m0i23JYYgGts; Thu,  9 Apr 2020 03:39:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 339024B156;
	Thu,  9 Apr 2020 03:39:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3524B12E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 03:07:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NnnmO4Hnccfd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 03:07:19 -0400 (EDT)
Received: from mx.kolabnow.com (mx.kolabnow.com [95.128.36.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07A524B116
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 03:07:19 -0400 (EDT)
Received: from localhost (unknown [127.0.0.1])
 by ext-mx-out002.mykolab.com (Postfix) with ESMTP id 87520BB8;
 Thu,  9 Apr 2020 09:07:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kolabnow.com; h=
 content-type:content-type:content-transfer-encoding:mime-version
 :references:in-reply-to:message-id:date:date:subject:subject
 :from:from:received:received:received; s=dkim20160331; t=
 1586416036; x=1588230437; bh=CR6YNXrsOFFgGGN4E5h4mEiC7xqdpy0fPI3
 euxlrRik=; b=hV2TUNwJO5MJ2HIDsZTAGAoyMMYw1shO1io2Z+OaLWJR6uS6SFs
 ApD8Xh9Zj29Z6f8iFz249nu4R3j4EJBU6WmIamE5XQy5v+JPInUaCFd8siPb3zw3
 kBauPIUue9EMo2URDi9aLLnwEZgusLXdD1gfYc/F88sfyTAJlQrrJvxjEJagcIwt
 Y9w341+MLh+kvXPwHPvpF1ExHOgE8bzlIyRdvldMvFv27NOzBUgMtcvFVR3Om81d
 n61jSIVlzN2nZPU4F/xpn3PuZtecjssI0LCJindaFQGWpDGSlg97hVlCHK3o+2ZE
 KHqPzI+nr2TlELjcGi+0RfSQGbmRGLeg1Eupev0lQ84qGuq3KtMYntttI0Du3e1D
 WlaYC94qGE3hpzUemlqromTKDYPqIc0Q697HGosu0fjmt9qcEfNL2hBc9Wlri+Kh
 cU4vjgK0YVT4Dwvn0HHcuAPbhYGoB3dootjQ8ml5HAkv8kA9br+P4D5sLqvnujRY
 rkIs2H5vdnOMv0W08ffI/Gc/CMZlDetfY8s+K69Ry3udMsVIy/MjvwyVSY2stzN3
 wHDVlMD/qnjh+nLSzezaBv1gIvZnIFm7zEFyL05Gg1UxywFFyFqjPLf9ZETyRoKM
 wIvmk9yPvK3HBbdkza0j3ltoblnbkQtF/h0nsAgwHrv7BLnyKNEJyNy4=
X-Virus-Scanned: amavisd-new at mykolab.com
Received: from mx.kolabnow.com ([127.0.0.1])
 by localhost (ext-mx-out002.mykolab.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gPRTEy1MsLlq; Thu,  9 Apr 2020 09:07:16 +0200 (CEST)
Received: from int-mx001.mykolab.com (unknown [10.9.13.1])
 by ext-mx-out002.mykolab.com (Postfix) with ESMTPS id B59B83E1;
 Thu,  9 Apr 2020 09:07:16 +0200 (CEST)
Received: from ext-subm002.mykolab.com (unknown [10.9.6.2])
 by int-mx001.mykolab.com (Postfix) with ESMTPS id 194D6526;
 Thu,  9 Apr 2020 09:07:15 +0200 (CEST)
From: Federico Vaga <federico.vaga@vaga.pv.it>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 03/35] docs: fix broken references to text files
Date: Thu, 09 Apr 2020 09:07:13 +0200
Message-ID: <2427906.fv9odQMh6t@harkonnen>
In-Reply-To: <2e12bf13355bd06748fed5d135fd4de3d94ad5fd.1586359676.git.mchehab+huawei@kernel.org>
References: <cover.1586359676.git.mchehab+huawei@kernel.org>
 <2e12bf13355bd06748fed5d135fd4de3d94ad5fd.1586359676.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 09 Apr 2020 03:39:36 -0400
Cc: kvm@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Akira Yokosawa <akiyks@gmail.com>, dri-devel@lists.freedesktop.org,
 linux-unionfs@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, Harry Wei <harryxiyou@gmail.com>,
 Alex Shi <alex.shi@linux.alibaba.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 kvm-ppc@vger.kernel.org, David Airlie <airlied@linux.ie>,
 Doug Ledford <dledford@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
 linux-arm-kernel@lists.infradead.org, Jade Alglave <j.alglave@ucl.ac.uk>,
 Daniel Lustig <dlustig@nvidia.com>, Mike Leach <mike.leach@linaro.org>,
 Andrea Parri <parri.andrea@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Nicholas Piggin <npiggin@gmail.com>, Maxime Ripard <mripard@kernel.org>,
 Luc Maranget <luc.maranget@inria.fr>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 David Howells <dhowells@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Marc Zyngier <maz@kernel.org>,
 linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org
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

On Wednesday, April 8, 2020 5:45:55 PM CEST Mauro Carvalho Chehab wrote:
> Several references got broken due to txt to ReST conversion.
> 
> Several of them can be automatically fixed with:
> 
> 	scripts/documentation-file-ref-check --fix
> 
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org> #
> hwtracing/coresight/Kconfig Signed-off-by: Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org>
> ---
>  Documentation/memory-barriers.txt                    |  2 +-
>  Documentation/process/submit-checklist.rst           |  2 +-
>  .../translations/it_IT/process/submit-checklist.rst  |  2 +-

Acked-by: Federico Vaga <federico.vaga@vaga.pv.it>



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
