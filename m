Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B822A9F6
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 22:17:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685139445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HlI3q1WPiCFI6LWKYg3D5mzmyQa8cYBk2N4tMj4HLGQ=;
	b=ZLtr38GLB3QLggnvIcY//4Woaa0BgQsm8X4di/r9n6wgkKJgWZgrury1iWQ++6BYIJHHdZ
	exSk6vKdDf+ZHVY4vPbd03T957E8Qt8eGk8nHZSdA8O8059DqvGEJpchtINFL6+1juwSZH
	eU6vrctb+py1P2j+ZNxRvj9EqrPxhAQ=
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
Subject: [PATCH kvmtool 02/21] update_headers: Add missing entries to list of headers to copy
Date: Fri, 26 May 2023 22:16:53 +0000
Message-ID: <20230526221712.317287-3-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
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
index 4c1be7e84a95..5720151972a1 100755
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
2.41.0.rc0.172.g3f132b7071-goog

