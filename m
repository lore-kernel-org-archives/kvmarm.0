Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283BFC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 17:20:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A4A4B89F;
	Mon,  7 Nov 2022 12:20:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zamwcUbYseKA; Mon,  7 Nov 2022 12:20:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 720674B869;
	Mon,  7 Nov 2022 12:20:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D82D44B850
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:20:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9-Ngj56WPgPQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:20:53 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7FA54B84E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:20:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667841653;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=O1uODv2NTtFh6nrlGSnkHycdHBAbqkNdNpxthhd40ck=;
 b=OgpvAbzzblB3UhPpUGyAA7ot/b0WIyEoI76sZfVzIAID1yfKlTMNpXsTvHCH5Ov0H9NLNQ
 BDZznaO/cOS+irOXutP6nNjgAzjH5z+ppgaCFg9Z8juONBUqw/jMf98tqTFsjVZqVx8WWM
 3WMpigiNSiSoSHV0eDTIad3x1IoXgvM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-NC8MfLbPPG-dLv78oABmfw-1; Mon, 07 Nov 2022 12:20:47 -0500
X-MC-Unique: NC8MfLbPPG-dLv78oABmfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74B1F85A5A6;
 Mon,  7 Nov 2022 17:20:46 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC61C15BB5;
 Mon,  7 Nov 2022 17:20:46 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v5 8/8] Documentation: document the ABI changes for
 KVM_CAP_ARM_MTE
In-Reply-To: <20221104011041.290951-9-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-9-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Mon, 07 Nov 2022 18:20:44 +0100
Message-ID: <87a6523clv.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

On Thu, Nov 03 2022, Peter Collingbourne <pcc@google.com> wrote:

> Document both the restriction on VM_MTE_ALLOWED mappings and
> the relaxation for shared mappings.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  Documentation/virt/kvm/api.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
