Received: from mail.208.org (unknown [183.242.55.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A0B3FEF
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 04:57:45 +0000 (UTC)
Received: from mail.208.org (email.208.org [127.0.0.1])
	by mail.208.org (Postfix) with ESMTP id 4R2K3W31d7zBR7b2
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 12:57:43 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
	content-transfer-encoding:content-type:message-id:user-agent
	:references:in-reply-to:subject:to:from:date:mime-version; s=
	dkim; t=1689310662; x=1691902663; bh=CsJiRvlfiU+SLN3sgAfoRbBp9D/
	h+nRJSRaz5ccoFlM=; b=tSghKWhRKhmDxmG7JeqJBo4v13llPgRRmyHwPHBQmA/
	M/93yk8QzyXmqYsb5eCOAqAk1dH1nFQPXOQ/sKPIhBhS4sSrhlvOfltSCbh3BC0a
	XSpKL5OEsxu4jheJdSJWmhNUh29fzuv+UBlBwEa0SgG3+6a+WPugnY8hVLfeZRjd
	+EtSBn/SAyNWRdcC0bat166qniLVzs4TlsL83wBKunYqZgrRhuT65fP+Q10X0tTP
	fAqWePEPu8KgQ6hB4pLFu3WnY/VCw3xiVLN357TtLpSLtTgpAqtF3Sab9mTVuZeh
	1gtRT+KrY9nBffYn5gv/ciZb//yidCMLPi/3az1z+8A==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
	by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JX0RwDOeUZE2 for <kvmarm@lists.linux.dev>;
	Fri, 14 Jul 2023 12:57:42 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
	by mail.208.org (Postfix) with ESMTPSA id 4R2K3V3fxjzBHXhN;
	Fri, 14 Jul 2023 12:57:42 +0800 (CST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 14 Jul 2023 12:57:42 +0800
From: chenqingyun001@208suo.com
To: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com,
 will@kernel.org
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: [PATCH] KVM: arm64:Use #include <linux/kprobes.h> instead of
 <asm/kprobes.h>
In-Reply-To: <tencent_2099141F01FC6C32AAA20B385053A477C507@qq.com>
References: <tencent_2099141F01FC6C32AAA20B385053A477C507@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <3d56cf129c2cf1cf53f19ebe3c23a803@208suo.com>
X-Sender: chenqingyun001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

Since <asm/kprobes.h> is a kernel-proprietary header file, it
should not be included by user-space programs.
And <linux/kprobes.h> is a public header file,
which provides some functions for registering
and unregistering probes

Signed-off-by: Qingyun Chen <chenqingyun001@208suo.com>
---
  arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c 
b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index b35a178e7e0d..072471df8b1b 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -9,7 +9,7 @@
  #include <linux/compiler.h>
  #include <linux/kvm_host.h>

-#include <asm/kprobes.h>
+#include <linux/kprobes.h>
  #include <asm/kvm_asm.h>
  #include <asm/kvm_emulate.h>
  #include <asm/kvm_hyp.h>
