Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28983C34
	for <kvmarm@lists.linux.dev>; Tue, 14 Mar 2023 13:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678800946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=aCkYXJFK5QPT+628o9HJuj3r1H4jPaiLpmFUDfEuBCucjE+Y+/PiJ2h69tk6aCx+MYnlP/
	0hUSumtD8O1Wr59aBx6hmNwWIgvGlKkqmmpwPd1PXLy6t1BuKDmVOzApQy1yYNYUSkj65s
	Dy9gJ4n1FNjKwMwmDUeUhVBsLeHvkOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-_K-F8YixOEO4hMpA-D9TgQ-1; Tue, 14 Mar 2023 09:35:40 -0400
X-MC-Unique: _K-F8YixOEO4hMpA-D9TgQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7191C1875041;
	Tue, 14 Mar 2023 13:35:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B60ED400F4F;
	Tue, 14 Mar 2023 13:35:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Gavin Shan <gshan@redhat.com>,
	Steven Price <steven.price@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 0/6] KVM: Standardize on "int" return types instead of "long"
Date: Tue, 14 Mar 2023 09:35:36 -0400
Message-Id: <20230314133536.3051967-1-pbonzini@redhat.com>
In-Reply-To: <20230208140105.655814-1-thuth@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

Queued, thanks.

Paolo


