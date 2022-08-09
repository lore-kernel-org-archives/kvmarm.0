Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADAEC25B06
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 10:28:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 910E84C2A5;
	Tue,  9 Aug 2022 06:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UG3gtDqIkZeN; Tue,  9 Aug 2022 06:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50DE44C4B5;
	Tue,  9 Aug 2022 06:28:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1BE4CD33
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 03:16:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zriowWCdzOWf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 03:16:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D31E4CB96
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 03:16:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660029401;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=pFDs6xidhpbw1qYaUFr1MfUDhoMVpVETbRmiPl3tRsM=;
 b=Khza/dN1QoNhC0Ta2bpD7qkDZuz1OyCI0xm9ynaHUH6d0wtVYh4Msr2s8n9qVjNWkjVZEd
 UMbKZtyKZdcZ391G92A/oJRB6lT6pz+bN7HAW8xs4uLN4WfnwitlV8D8p2piYXiLTUxXUs
 DmlzWo53/8c3XrA8MdAtgXuhQKQ0F4I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-wVvB783QNq-aMoXaZIWmxA-1; Tue, 09 Aug 2022 03:16:38 -0400
X-MC-Unique: wVvB783QNq-aMoXaZIWmxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B753801FE4;
 Tue,  9 Aug 2022 07:16:38 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.65])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DC411415125;
 Tue,  9 Aug 2022 07:16:35 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
Date: Tue, 09 Aug 2022 09:16:33 +0200
In-Reply-To: <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com> (Gavin Shan's
 message of "Tue, 9 Aug 2022 18:45:26 +1000")
Message-ID: <87o7wtnay6.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Tue, 09 Aug 2022 06:28:50 -0400
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, andrew.jones@linux.dev,
 mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

* Gavin Shan:

>> __builtin_thread_pointer doesn't work on all architectures/GCC
>> versions.
>> Is this a problem for selftests?
>> 
>
> It's a problem as the test case is running on all architectures. I think I
> need introduce our own __builtin_thread_pointer() for where it's not
> supported: (1) PowerPC  (2) x86 without GCC 11
>
> Please let me know if I still have missed cases where
> __buitin_thread_pointer() isn't supported?

As far as I know, these are the two outliers that also have rseq
support.  The list is a bit longer if we also consider non-rseq
architectures (csky, hppa, ia64, m68k, microblaze, sparc, don't know
about the Linux architectures without glibc support).

Thanks,
Florian

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
