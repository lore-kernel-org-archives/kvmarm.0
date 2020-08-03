Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BE4C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 08:18:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35D092065E
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 08:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWVUVpsK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35D092065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3134B6F7;
	Mon,  3 Aug 2020 04:18:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mXkpUaPyN7mq; Mon,  3 Aug 2020 04:18:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8F14B6CB;
	Mon,  3 Aug 2020 04:18:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D94E74B6CE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 04:18:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dHkeZ1oenC8R for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 04:18:06 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 019BE4B6CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 04:18:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596442685;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NP/o3GjxkLVkr6e7MapLhFiFMIoyPvP6WB13cO9Vx2A=;
 b=SWVUVpsK2j95KDZeYJgor8zorIzU3Z+BbIedmaBrokWhxMljfAFrQA3LflL2cYNesVLJbd
 REcWW4E12C49WjqnroEj+8gP45YYEpOr+HrSS4H9ATQ5cHWQ8LrQ0egwd2ZJ6W3ba2b7f3
 iJJZ/+7rcDWOQ8S4ILlHVIBLGnY0m3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-Mt-csW5eNAqME327j-YKKw-1; Mon, 03 Aug 2020 04:18:02 -0400
X-MC-Unique: Mt-csW5eNAqME327j-YKKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC40D8010EB;
 Mon,  3 Aug 2020 08:18:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.111])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E287F1A7C8;
 Mon,  3 Aug 2020 08:17:58 +0000 (UTC)
Date: Mon, 3 Aug 2020 10:17:56 +0200
From: Andrew Jones <drjones@redhat.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 00/20] KVM: arm64: Rewrite page-table code and fault
 handling
Message-ID: <20200803081756.6y2plzh3p7uzjljo@kamzik.brq.redhat.com>
References: <20200730153406.25136-1-will@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20200730153406.25136-1-will@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On Thu, Jul 30, 2020 at 04:33:46PM +0100, Will Deacon wrote:
> In terms of testing, I've done the usual Debian installer type things, but
> Quentin has also written targetted guest code [1] which we used to
> exercise dirty logging page-table collapse and coalescing.
...
> [1] https://android-kvm.googlesource.com/misc/+/refs/heads/qperret/pgtable-test

Hi Quentin,

Any reason you didn't look into extending

 tools/testing/selftests/kvm/dirty_log_test

and, if necessary, the AArch64 KVM selftests framework?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
