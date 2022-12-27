Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9A1C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Dec 2022 13:03:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D15F74B843;
	Tue, 27 Dec 2022 08:03:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CL02awXeZe7o; Tue, 27 Dec 2022 08:03:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A11AF4B886;
	Tue, 27 Dec 2022 08:03:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84DD04B879
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Dec 2022 08:03:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzusoxWFi-aT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Dec 2022 08:03:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 267274B843
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Dec 2022 08:03:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1672146226;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=itmwXqUo01mTV85no/9ZNLho2BNM+XUgesQju+SpFwM=;
 b=UeITphuNzGnkuWLOPV2kIiLlXY5SgMJ5WGlM/3Ak+hJ9JTqJI6ot9OmW8vTIXWJAcpLMKy
 sac0GMq8kiZZe9v4S7Kl2EBD5a9ad8IIKsgohjKa1T+TzuosgLjpzN0S2aNcoXmw8nVdHi
 9Vg7d8eyz8Z+GnSIjDVkF5UYObD/uH8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-al1j6ULROiyc5y_rGIER3A-1; Tue, 27 Dec 2022 08:03:41 -0500
X-MC-Unique: al1j6ULROiyc5y_rGIER3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C26A0101A521;
 Tue, 27 Dec 2022 13:03:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com
 (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2C14DC15BA0;
 Tue, 27 Dec 2022 13:03:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 00/50] KVM: Rework kvm_init() and hardware enabling
Date: Tue, 27 Dec 2022 08:02:50 -0500
Message-Id: <20221227130249.1650197-1-pbonzini@redhat.com>
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
References: 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Michael Ellerman <mpe@ellerman.id.au>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>
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

Queued, thanks.  I will leave this in kvm/queue after testing everything
else and moving it to kvm/next; this way, we can wait for test results
on other architectures.

Paolo


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
