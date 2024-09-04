Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46A51DC1B1
	for <kvmarm@lists.linux.dev>; Wed,  4 Sep 2024 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725462244; cv=none; b=ELUAbb9L6Je1Zu7QSY3RgxIlXtvmvrAEV9DAGyXE61ifktKUQmgDG0X08oScXbf2d2a13TH4D6r/IRQRZ8iowJ4Asdz3qAsBopL7MrAvvUwWSf73F3UUbwTYpwsllAeylVQZrb+K4tKK4M3BzSnaHWAUu1sTj5ZWR8OEXIGa5SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725462244; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI5zAJXzpWUoJZgABxcHIPoXgEGskaftgQqDoqKalKWQ7xTlurz0WKDipYE1rZcvMeOpV25cRSSEe7u+ef8O7NPPuJzgI5sxztVa3aOy+mtWP8MEHS/jtTp56IWGoUZHYq1mLjnHzoTnoa9wdawc8FaLdrU1GORiST3KhF37mvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ll8HoOkR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ll8HoOkR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725462241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=Ll8HoOkRe3qwTVfFKLaY5+vNGKRmlFzGa/2f6eFmcwF2G8tUkAKxoX4vAXLlYWCAskpSKq
	of2HIHt03Pf1tvg87Kcd4sVtf7MbFAHcLYuGfogTD7bDuC/UtzPZ9wi4Bqu9M6c+ZpgoHQ
	37lB0YLD14/RcojDUbgnRdcWCKkqHgc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-BCdAfi9BNyOJcJCcVTiTfA-1; Wed,
 04 Sep 2024 11:03:57 -0400
X-MC-Unique: BCdAfi9BNyOJcJCcVTiTfA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC6E219560BD;
	Wed,  4 Sep 2024 15:03:52 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2A273000239;
	Wed,  4 Sep 2024 15:03:47 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v4 00/10] KVM: Register cpuhp/syscore callbacks when enabling virt
Date: Wed,  4 Sep 2024 11:03:44 -0400
Message-ID: <20240904150344.177870-1-pbonzini@redhat.com>
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Queued, thanks.

Paolo


