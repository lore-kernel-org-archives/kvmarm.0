Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10BB846D
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 07:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692776239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u62nPwHcShighjmVk2GZlC7k3Viptp+NNP/1gOvS9nc=;
	b=XD2xKlwnBjZg8WhoWpnQhUtpx2dyKfR3VPCg5aymeX0jN03zX45q6e6NOJs6Xhst0tEZWc
	J2MECK9HEJ7DjR12f0PeLUdRLkWndAoUXVYyQ2qukLbdqpiAI5eK6p1ySM0k2BHJKiWLx4
	JDUDzzLhW9LwqiNl8PaDLyCTaqRIdUM=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-YXYYzJ0YM6WOHWJi_fVesQ-1; Wed, 23 Aug 2023 03:37:16 -0400
X-MC-Unique: YXYYzJ0YM6WOHWJi_fVesQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 407CB381AE57;
	Wed, 23 Aug 2023 07:37:15 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4311492C18;
	Wed, 23 Aug 2023 07:37:14 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
 <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 James Morse <james.morse@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh
 <surajjs@amazon.com>, Shaoqin Huang <shahuang@redhat.com>, Jing Zhang
 <jingzhangos@google.com>
Subject: Re: [PATCH v9 00/11] Enable writable for idregs DFR0,PFR0,
 MMFR{0,1,2,3}
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20230821212243.491660-1-jingzhangos@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Wed, 23 Aug 2023 09:37:13 +0200
Message-ID: <878ra28b12.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9

On Mon, Aug 21 2023, Jing Zhang <jingzhangos@google.com> wrote:

> This patch series enable userspace writable for below idregs:
> ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.
> A vm ioctl is added to get feature ID register writable masks from userspace.
> A selftest is added to verify that KVM handles the writings from user space
> correctly.
> A relevant patch from Oliver is picked from [3].
>
> ---
>
> * v8 -> v9
>   - Rebase on v6.5-rc7.
>   - Don't allow writable on RES0 fields and those fields not exposed by KVM.
>   - Fixed build dependency issue for system register definition generation in
>     selftest.

What about the changes to the userspace interface as proposed by Marc in
<86sf8hg45k.wl-maz@kernel.org>?

