Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5FBC54EE9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 15:11:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787644B638;
	Mon, 19 Sep 2022 11:11:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tFU9sqdM9PxM; Mon, 19 Sep 2022 11:10:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 571BA4B64C;
	Mon, 19 Sep 2022 11:10:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DEDD4B63B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 11:10:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F+HLk8WBTM+I for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 11:10:57 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E14324B638
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 11:10:56 -0400 (EDT)
Date: Mon, 19 Sep 2022 17:10:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663600255;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=S6VNrPMZk2oYZl8Kyyhs50ZrHrkKLgAs8UjT+ZS8d8s=;
 b=r7CqAmKaQxqObb0KeFKWfHvmgIYg5vGzswzAO9ld5OX2wK0XnaWd0TO2QY6FcJCa7ATWGc
 Z7PnB9VoTK/d5TkqySwgo16MeW0YEsan+KqaoeON2+kyvxMkn5unoB2emLPdNNKEk+dEdu
 81M01VhHFpfpFOsAUnYAT9qREdAz9x4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v4 07/12] arm: pmu: Basic event counter
 Tests
Message-ID: <20220919151049.jtujswjyv5k34log@kamzik>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-8-eric.auger@redhat.com>
 <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, andrew.murray@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On Mon, Sep 19, 2022 at 10:30:01PM +0800, Zenghui Yu wrote:
> Hi Eric,
> 
> A few comments when looking through the PMU test code (2 years after
> the series was merged).

Yes, these patches were merged long ago. Now you need to send patches,
not comments.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
