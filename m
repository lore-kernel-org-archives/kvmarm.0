Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C2930643
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ESX4fbpJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700140144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MonhjC3WXqcY3h7WdCFO745+80UlcrRmMeuYZtAtOeE=;
	b=ESX4fbpJVptFZrDqzB4c4rfCiRXQtxye2o7hRIGuqyWYMFKJLbRBbznClE5zzzXFyyB/7H
	f0krI2vK35XQu3FqQ6ELEq52NugAqcaPAlEHJIiWr0eZDixE8U9mltwCxxlxi7DuQvWfSh
	j5gd3eQxtp011sYWERC+6OxKGG7vgWI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139-Xo8IBKGHMtuhjaOTJw4t7w-1; Thu,
 16 Nov 2023 08:09:01 -0500
X-MC-Unique: Xo8IBKGHMtuhjaOTJw4t7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D054F3C11A0C;
	Thu, 16 Nov 2023 13:09:00 +0000 (UTC)
Received: from localhost (unknown [10.39.193.127])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2758640C6EB9;
	Thu, 16 Nov 2023 13:08:59 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Jianyong Wu <jianyong.wu@arm.com>, maz@kernel.org, james.morse@arm.com,
 will@kernel.org
Cc: rmk@armlinux.org.uk, salil.mehta@huawei.com, suzuki.poulose@arm.com,
 oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, justin.he@arm.com,
 jianyong.wu@arm.com
Subject: Re: [PATCH] arm64/kvm: Introduce feature extension for SMCCC filter
In-Reply-To: <20231116114152.912344-1-jianyong.wu@arm.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20231116114152.912344-1-jianyong.wu@arm.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Thu, 16 Nov 2023 14:08:58 +0100
Message-ID: <877cmhq1zp.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Thu, Nov 16 2023, Jianyong Wu <jianyong.wu@arm.com> wrote:

> 821d935c87b introduces support for userspace SMCCC filtering, but lack
> of a way to tell userspace if we have this feature. Add a corresponding
> feature extension can resolve this issue.
>
> For example, the incoming feature Vcpu Hotplug needs the SMCCC filter.
> As there is no way to check this feature, VMM will run into error when
> it calls this feature on an old kernel. It's bad for backward compatible.

Can't you simply query via KVM_HAS_DEVICE_ATTR whether the SMCCC
filtering controls exist?

>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  Documentation/virt/kvm/api.rst | 3 ++-
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
>

