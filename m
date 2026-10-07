Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4373E9C17
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358847; cv=none; b=ID9oGyIRzes1TAse/5dTiMj0wnvl1Xh9qvt+AQ2EeYQROFTmo2n/zGTI6S8aj+0G8SxmaTZH50HxM6nzqMHJ/GObBkB52UEQBHhhZoRB1Zod23ulvFh5DCd3ppbznp8oqbCdGZfGXsbsD9OplIoLetZrxJeZeaddcV2vxgbqMPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358847; c=relaxed/simple;
	bh=zpeDri79jDSPiCNzLVYdDR1QwvFynzb8SDt007S+BUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d/Ir4tAExOVSwChAsynr+l0rrtzn6vUBd5kutQ+pxTyIkZAqtm8uymccIuD4lKgnhof1doTnnpRD560PiWMyN6O0xH233+q4FIT7jb9rll/6VhPKDrMUlq6NsfOIitgZgvR22/th2ejnRZuAySbmNv7YycaZBLtNI9tqIxjIaFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GQ0HUcgS; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GQ0HUcgS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zpeDri79jDSPiCNzLVYdDR1QwvFynzb8SDt007S+BUU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791358844; v=1; x=1791963644;
 b=GQ0HUcgSurvnNEPQRadteMHVUP9hfiliYf1hE7CLR0UlJyiJyAQ/HwZoWeHYOymnIlOPwqz+
 iOR9xz4aX2IuNDV65Y2Q6casyMXzQ40euDvd/b+IyzKfvTTRl8rjsoftU9SQy9PDg+JYreoTy0t
 igLzirUAOQ3GakM5AX8KH/C4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2885e374f357218a;
	Wed, 07 Oct 2026 07:40:43 +0000
X-Mizu-Trace-ID: 2885e374f357218a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	James Houghton <jthoughton@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
Date: Wed,  7 Oct 2026 08:40:37 +0100
Message-Id: <20261007074037.316564-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922071945.693714-1-fuad.tabba@linux.dev>
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sean, Paolo,

Gentle ping on this series.

Cheers,
/fuad
