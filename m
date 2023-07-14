Received: from mail.208.org (unknown [183.242.55.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06ED5224
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 04:44:45 +0000 (UTC)
Received: from mail.208.org (email.208.org [127.0.0.1])
	by mail.208.org (Postfix) with ESMTP id 4R2JmJ00QkzBS5q0
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 12:44:31 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
	content-transfer-encoding:content-type:message-id:user-agent
	:references:in-reply-to:subject:to:from:date:mime-version; s=
	dkim; t=1689309871; x=1691901872; bh=uqV/KVaosrZlp0sdvjEgoWRj1jH
	nPyBvXFKURudroCg=; b=ZOzmu5JDNWwKS+/E19qIDFG1wqAvDrFwi4NJL6ZQlnC
	XidPQvfuQZyOAnxALTb/VQHOD9f39m37VLUZ+YTZU+hliByn3KEQ7qdppO2jsrLj
	W7cFehWoKhRfkh7KPhDr8k3pr1+3DtzdzVJpf1lAoIenakziOsAUPIHNLVQ/AVNx
	/04XIJ//cHOWq+TGkGoYZJ/jIdb0BN1leusgAJ7EOJxC+uluHhFtCF8kxn1PGlQo
	OGuejtSd2KzrGwfyVShGEImVzTmRMEcWZpF1VXdLb5rAHEJkYgeSIjAJBQjcsihw
	k1lFnHkiWYR9t8Xq2OgZggIEVzid6T0dBrfD4XPvXGA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
	by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JOu9nVwZ0x7v for <kvmarm@lists.linux.dev>;
	Fri, 14 Jul 2023 12:44:31 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
	by mail.208.org (Postfix) with ESMTPSA id 4R2JmH3R0hzBRSVj;
	Fri, 14 Jul 2023 12:44:31 +0800 (CST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 14 Jul 2023 12:44:31 +0800
From: chenqingyun001@208suo.com
To: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com,
 will@kernel.org
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: [PATCH] KVM: arm64:space required before the open parenthesis '('
In-Reply-To: <tencent_40330B3E7AF84464D54533700BA6A0EF3F08@qq.com>
References: <tencent_40330B3E7AF84464D54533700BA6A0EF3F08@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <46eb0d5df76c8ac67c752d747b58be55@208suo.com>
X-Sender: chenqingyun001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

To make the code easier and understandable, put a space
before the opening parenthesis to distinguish functions
from parentheses for other purposes. Doing so can also
avoid some potential errors or ambiguities.

Signed-off-by: Qingyun Chen <chenqingyun001@208suo.com>
---
  arch/arm64/kvm/inject_fault.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c 
b/arch/arm64/kvm/inject_fault.c
index 0bd93a5f21ce..3cc891c0b292 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -29,7 +29,7 @@ static void pend_sync_exception(struct kvm_vcpu *vcpu)
       * changing context, and the exception itself can be delayed
       * until the next entry.
       */
-    switch(*vcpu_cpsr(vcpu) & PSR_MODE_MASK) {
+    switch (*vcpu_cpsr(vcpu) & PSR_MODE_MASK) {
      case PSR_MODE_EL2h:
      case PSR_MODE_EL2t:
          kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
