Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF16CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 06:42:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81B0249E49;
	Tue, 26 Apr 2022 02:42:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EzRWtM+yUv7V; Tue, 26 Apr 2022 02:42:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA104B0D0;
	Tue, 26 Apr 2022 02:42:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2304A0FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 02:42:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZtEJ7P-j-S8D for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 02:41:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F73249F5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 02:41:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1650955318;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7abwP0OsWtbN83lK5y79QzB8uIny3w43c2wo+0VTZhQ=;
 b=f6IlQX5hipuMzeAcZIQiK7Scm5paVsMw8XfQrFlkmiDogVa62W42x6CGWSdESwIBvDGSaA
 aGQPKknicqO8wufcwrPtZlMPcbAc/lyiDAwUaPzcUw2ejLb0YKwEmU/TTjCNalDJBlJihM
 AnupBcio3cynWazDvbHIuItFBeBJz/8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-Rnrn1RSFNQSPcBQeg6zhLQ-1; Tue, 26 Apr 2022 02:41:57 -0400
X-MC-Unique: Rnrn1RSFNQSPcBQeg6zhLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B8AD18A658A;
 Tue, 26 Apr 2022 06:41:35 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63FAC40470C2;
 Tue, 26 Apr 2022 06:41:26 +0000 (UTC)
Subject: Re: [PATCH v6 5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
To: Raghavendra Rao Ananta <rananta@google.com>, Marc Zyngier
 <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-6-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8e67bc1b-05c9-f2d3-1580-2c1f3118a769@redhat.com>
Date: Tue, 26 Apr 2022 14:41:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220423000328.2103733-6-rananta@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
> Since the doc also covers general hypercalls' details,
> rather than just PSCI, and the fact that the bitmap firmware
> registers' details will be added to this doc, rename the file
> to a more appropriate name- hypercalls.rst.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>   Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
>   1 file changed, 0 insertions(+), 0 deletions(-)
>   rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> similarity index 100%
> rename from Documentation/virt/kvm/arm/psci.rst
> rename to Documentation/virt/kvm/arm/hypercalls.rst
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
