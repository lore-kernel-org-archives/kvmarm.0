From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?=
	<j.fanguede@virtualopensystems.com>
Subject: [RFC 3/4] kvm-all: Pre-run cache coherency maintenance
Date: Tue,  5 May 2015 11:13:46 +0200
Message-ID: <1430817227-6278-4-git-send-email-j.fanguede@virtualopensystems.com>
References: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu, tech@virtualopensystems.com, =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?= <j.fanguede@virtualopensystems.com>, Paolo Bonzini <pbonzini@redhat.com>, "open list:Overall" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Inform the cache coherency maintenance of an exit from userspace.

Signed-off-by: J=C3=A9r=C3=A9my Fangu=C3=A8de <j.fanguede@virtualopensy=
stems.com>
---
 kvm-all.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kvm-all.c b/kvm-all.c
index 28f4589..c4b15b0 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1802,6 +1802,7 @@ int kvm_cpu_exec(CPUState *cpu)
         }
=20
         kvm_arch_pre_run(cpu, run);
+        kvm_arch_cache_coherency_pre_run();
         if (cpu->exit_request) {
             DPRINTF("interrupt exit requested\n");
             /*
--=20
1.9.1

