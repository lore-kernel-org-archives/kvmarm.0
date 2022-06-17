Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A84C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 10:03:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6554B2B1;
	Fri, 17 Jun 2022 06:03:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VN6LCE0xK-a5; Fri, 17 Jun 2022 06:02:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E4F34B275;
	Fri, 17 Jun 2022 06:02:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 805654B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 06:02:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pCrzR5O3auzs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 06:02:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1734B1C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 06:02:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655460177;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type: content-transfer-encoding:content-transfer-encoding;
 bh=yB/Z1x1JVGc/AmBIB1Ow5YmWeNlwez1k9t75gRyBlx0=;
 b=KOCfvXn5QV8aQnWfo5pioQG5mdkyymTDYN+m5Hdkg95Osg5aiBRb4m6Hzj8kJ+07CW2BIf
 4V2CmoKe6brQCnbQrP8kFu0pyL6b0S0e0Tv4p7fuA0OMuj7ozIECr+PHst6aXzMRUgNnyB
 9buoTafmjMvRrO2LrmiRG4Jl081w8/U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-cV8ZjiqIMvaxDQo9LZwYCg-1; Fri, 17 Jun 2022 06:02:53 -0400
X-MC-Unique: cV8ZjiqIMvaxDQo9LZwYCg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9531A29DD9B8;
 Fri, 17 Jun 2022 10:02:53 +0000 (UTC)
Received: from [10.72.12.21] (ovpn-12-21.pek2.redhat.com [10.72.12.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3435E40334D;
 Fri, 17 Jun 2022 10:02:49 +0000 (UTC)
To: "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
 <kvmarm@lists.cs.columbia.edu>
From: Gavin Shan <gshan@redhat.com>
Subject: [Question] remote_tlb_flush statistic is missed from
 kvm_flush_remote_tlbs() ?
Message-ID: <25c7cc69-64ef-d42b-dc0b-968d7415b111@redhat.com>
Date: Fri, 17 Jun 2022 18:02:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Folks,

We're reviewing upstream commits and found that it seems that
++kvm->stat.generic.remote_tlb_flush has been missed from
kvm_flush_remote_tlbs(). If I'm correct, we still need to
increase the statistic in kvm_flush_remote_tlbs()?

History about the changes:

ce6a7007048b staging: r8188eu: remove {read,write}_macreg
     The changes were NOT there any more.
419025b3b419 Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next
     The changes were still there
38f703663d4c KVM: arm64: Count VMID-wide TLB invalidations
     The changes were initially introduced by this commit,
     to increase 'kvm->stat.generic.remote_tlb_flush' in
     kvm_flush_remote_tlbs().

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
