Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D29C49EA2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 07:06:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D306B61410
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 07:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D306B61410
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3896E49F82;
	Tue, 15 Jun 2021 03:06:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kFZIQ4IPnida; Tue, 15 Jun 2021 03:06:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24A624B090;
	Tue, 15 Jun 2021 03:06:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9CEF4A195
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 03:06:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bDgxSB2SpyWz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 03:06:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA82349DE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 03:06:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623740809;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1bptQkqZVqAajaLHu25xIp56mYAPhq5K+DznNXOGR0E=;
 b=ih96Qtb+AugWtRO4zjNU0hlO0tGSglXwuR1o6G2h/++c+KLXiodeJ2qfomtOc/fKAqWgHl
 Vkjc8gMaggYDZv1q2aHNPa5RQs5se8q6vW8dGMdEt8UscyCLg0k6RgAuxAf7yRIdw35csR
 Bacjc9b6YQT8TPpEAPyB7Ewrb7XFN4k=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-2AjwCko6OKqQrI-alRwy2A-1; Tue, 15 Jun 2021 03:06:48 -0400
X-MC-Unique: 2AjwCko6OKqQrI-alRwy2A-1
Received: by mail-ed1-f71.google.com with SMTP id
 z16-20020aa7d4100000b029038feb83da57so21563517edq.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 00:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=1bptQkqZVqAajaLHu25xIp56mYAPhq5K+DznNXOGR0E=;
 b=bcesN7zLzX7BXmSL7k+9TFikpltaui5tWJBkYdrRQ1JZ61974iT3jFURh+3Vbo+uDF
 9EgQRqjKZEHoTW5+Se0STTHTFloc0zrRRGACiSEOg/PPY+whTzRVukSDEZv2ZKB/CLk3
 O+g7xGFLsnwZoOP07IqYeLBrjFw2expA08yG7Vp3CtNUYNbixbP5UWzLv/tn7cIAT2VC
 l1RdshlMTKVQa1C2QKk7ad8/MJOMdBEx5MhtrEttiLcSNqJtv0KK9YwiYpXzTmrV5iAm
 a3QYtLqfmRFu5e4nAxx3GEOEULrHYDKEeMtA4o3nEufgRGynkr/NzszXIgz/iShzr8YX
 Y0Hw==
X-Gm-Message-State: AOAM5326lWXe+j9NksjouMPK7c7unbGO+NlAEVhK5uieBvIHjEozOoNU
 hUFaDDoRRtOtsQawAthMlABGfSATHZCNodu/jUSKdGv4wfLSpC45wzhF28nR6FNOxrDmc8onp9G
 pQkQwLQ+Ttwjx4yc+simWgJhw
X-Received: by 2002:a05:6402:1e8b:: with SMTP id
 f11mr21756489edf.86.1623740807166; 
 Tue, 15 Jun 2021 00:06:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjr2XSQSGkPxI3dJja1mbqx7MqydkJIqxXPBC64kHnxRq+99yMj0rlssdO/n6Q7TVjtTbx4g==
X-Received: by 2002:a05:6402:1e8b:: with SMTP id
 f11mr21756454edf.86.1623740806968; 
 Tue, 15 Jun 2021 00:06:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id d4sm9179485ejo.98.2021.06.15.00.06.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Jun 2021 00:06:46 -0700 (PDT)
To: Leon Romanovsky <leon@kernel.org>, Jing Zhang <jingzhangos@google.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <YMg5xPbmK3myjIX8@unreal>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
Date: Tue, 15 Jun 2021 09:06:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMg5xPbmK3myjIX8@unreal>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 15/06/21 07:25, Leon Romanovsky wrote:
> Sorry for my naive questions, but how does telemetry get statistics
> for hypervisors? Why is KVM different from hypervisors or NIC's statistics
> or any other high speed devices (RDMA) that generate tons of data?

Right now, the only way is debugfs but it's slow, and it's disabled when 
using lockdown mode; this series is a way to fix this.

I sense that there is another question in there; are you wondering if 
another mechanism should be used, for example netlink?  The main issue 
there is how to identify a VM, since KVM file descriptors don't have a 
name.  Using a pid works (sort of) for debugfs, but pids are not 
appropriate for a stable API.  Using a file descriptor as in this series 
requires collaboration from the userspace program; howver, once the file 
descriptor has been transmitted via SCM_RIGHTS, telemetry can read it 
forever without further IPC, and there is proper privilege separation.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
