Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504B3200C4
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 16:34:17 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687278855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9YpD01o6UPhM5WsJPhZO7V/DerMefZkxr+zZT/DMt3w=;
	b=l269BUmws6WJNXZ2rJPbOyzNrMt4hsmaIkGKHGp3fexy5ujW9xom6pdPazB1SY3PmASoW7
	yypsD965CgcWE9X01JrAv66jnHwWhRS13ChJzuXrnfuCPAgD2jgMplGo2f9RsbHI3Gn7yP
	ZsfNlWfed4CqDbGX6LO7Om/RnT70eXI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 02/20] update_headers: Add missing entries to list of headers to copy
Date: Tue, 20 Jun 2023 11:33:35 -0500
Message-ID: <20230620163353.2688567-3-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There are a few headers in kvmtool that are not handled by the updater
script. Add them to the list of headers to update.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 util/update_headers.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 4c1be7e..5720151 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -10,6 +10,9 @@
 set -ue
 
 GENERIC_LIST="kvm.h \
+	      psci.h \
+	      vfio.h \
+	      vhost.h \
 	      virtio_9p.h \
 	      virtio_balloon.h \
 	      virtio_blk.h \
-- 
2.41.0.162.gfafddb0af9-goog

