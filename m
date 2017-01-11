From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH 4/6] docs: mention checkpatch in the README
Date: Wed, 11 Jan 2017 16:28:39 +0000
Message-ID: <20170111162841.15569-5-alex.bennee@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170111162841.15569-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 README.md | 1 +
 1 file changed, 1 insertion(+)

diff --git a/README.md b/README.md
index 5027b62..9462824 100644
--- a/README.md
+++ b/README.md
@@ -79,3 +79,4 @@ You can add the following to .git/config to do this automatically for you:
     [format]
         subjectprefix = kvm-unit-tests PATCH
 
+Please run the kernel's ./scripts/checkpatch.pl on new patches
-- 
2.11.0

