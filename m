Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10369ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 04:47:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EEA34CA1B;
	Fri,  9 Sep 2022 00:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uNy+ayh7PivC; Fri,  9 Sep 2022 00:47:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C254CB08;
	Fri,  9 Sep 2022 00:47:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 658DC4CA1B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:47:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJPn1cK5bUra for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 00:47:09 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57D324C278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:47:09 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3454647ff7dso6129797b3.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2022 21:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=cdmIqcLKbdujO9E0CyTHIQ8voTZsLtjL+NYg8vJd0vA=;
 b=cF3DR/sd0Wgsk/iGGH2d2gEDKFgjIg01OYfZMpnzvPrEAkaGz8AIJvL4s5mw+Nc0M8
 TN57/dyFDmY7Mih5VeJg2n7zTILQr7Z60pR9Ad3OqdHVl6hLeq4jjI0iOKLLBff2mbH2
 zuJaPOzq5hFBBbanpuK3JTsDOf12MxffmatefGt7Jv4VRIFMUQy949BHMEBXFg9eP0Rw
 K1Q8Pt4W4dkbazK+4K8UpIm0x3H+grQxr7mwcrTKI9WAaftcEl/JNJVJFuy/SEFGLs6P
 C25YPwSvZwjJCbFh3uRod4ipWKvVsBizabkX5Hwnit3V6MbbDvuvAPQ5a5pWGA4S7CwE
 hCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=cdmIqcLKbdujO9E0CyTHIQ8voTZsLtjL+NYg8vJd0vA=;
 b=rzq5hu/HEOvNPyKhfAPV7axqKTWMLIDsFYNSsBUJhm51bXbSAoM8N1UoZeCdavpnv4
 thsko1Y6PpxwiL3HvJuLO/VrGa4m1ab/ZSptg6LQ92Gt4MAb3pS57RwwBlOGqHoQ5zCX
 jpB/js0ugA3BAJ78jZaVQ2RSFdwLq6hF7JYrojub6kxbGDPCcZmJNrisaCSbqjCtx5R7
 8IZjlId/0YwPeUSAEM0jj+4gpBqGqcoioNAX6VbNWdUMIpkxy/YVWikRMdLZIXywvzHl
 y2AVS0N341p1aBsR6Uwu95pyMuJBu99G1BMYlW1NOzVdK9EjkcypRxeMq38PGVZ7hydu
 mFvw==
X-Gm-Message-State: ACgBeo3BK744ANpkr91Bvz49DJv9tj9oZ4Vh7ni+/SiACFZthNCvXLSp
 ap75DByqHucGDJ0tFJ4Gt9Q9Eg51U4I=
X-Google-Smtp-Source: AA6agR6fFEzordzXyp1eqlP2xn60Bj2CFzQfdITIpFijrIWoJ+bbNsN9lfrixj3WQl3w9vPwLiX971lXrz4=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:a0d:0:b0:689:9eee:348f with SMTP id
 k13-20020a5b0a0d000000b006899eee348fmr10500385ybq.111.1662698828939; Thu, 08
 Sep 2022 21:47:08 -0700 (PDT)
Date: Thu,  8 Sep 2022 21:46:35 -0700
In-Reply-To: <20220909044636.1997755-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-3-reijiw@google.com>
Subject: [PATCH 2/3] KVM: arm64: selftests: Refactor debug-exceptions to make
 it amenable to new test cases
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Split up the current test into a helper, but leave the debug version
checking in main(), to make it convenient to add a new debug exception
test case in a subsequent patch.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..e6e83b895fd5 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -246,7 +246,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	return id_aa64dfr0 & 0xf;
 }
 
-int main(int argc, char *argv[])
+static void test_guest_debug_exceptions(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -259,9 +259,6 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
-		       "Armv8 debug architecture not supported.");
-
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
@@ -294,5 +291,18 @@ int main(int argc, char *argv[])
 
 done:
 	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+		       "Armv8 debug architecture not supported.");
+	kvm_vm_free(vm);
+	test_guest_debug_exceptions();
+
 	return 0;
 }
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
