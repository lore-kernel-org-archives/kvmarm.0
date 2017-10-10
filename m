From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 28/28] arm64/sve: signal: Include SVE when computing AT_MINSIGSTKSZ
Date: Tue, 10 Oct 2017 19:38:45 +0100
Message-ID: <1507660725-7986-29-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The SVE context block in the signal frame needs to be considered
too when computing the maximum possible signal frame size.

Because the size of this block depends on the vector length, this
patch computes the size based not on the thread's current vector
length but instead on the maximum possible vector length: this
determines the maximum size of SVE context block that can be
observed in any signal frame for the lifetime of the process.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Alex Bennée <alex.bennee@linaro.org>
---
 arch/arm64/kernel/signal.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 3382e87..15bc2ad 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -595,8 +595,18 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user,
 	if (system_supports_sve()) {
 		unsigned int vq = 0;
 
-		if (test_thread_flag(TIF_SVE))
-			vq = sve_vq_from_vl(current->thread.sve_vl);
+		if (add_all || test_thread_flag(TIF_SVE)) {
+			int vl = sve_max_vl;
+
+			if (!add_all)
+				vl = current->thread.sve_vl;
+
+			/* Fail safe if something wasn't initialised */
+			if (WARN_ON(!sve_vl_valid(vl)))
+				vl = SVE_VL_MIN;
+
+			vq = sve_vq_from_vl(vl);
+		}
 
 		err = sigframe_alloc(user, &user->sve_offset,
 				     SVE_SIG_CONTEXT_SIZE(vq));
-- 
2.1.4
