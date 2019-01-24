From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 6/7] lib: argv: Implement argv_find() for test
 parameters
Date: Thu, 24 Jan 2019 11:16:33 +0000
Message-ID: <20190124111634.4727-7-alexandru.elisei@arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E184A3F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:17:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOZHNuO7poN0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 06:17:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB244A412
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:17:07 -0500 (EST)
In-Reply-To: <20190124111634.4727-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The current behavior when searching for a specific parameter is to exit
with an error when the first unexpected parameter is found.

The function argv_find() will search for a specific parameter, ignoring all
other parameters.

Consumers for the function will be added in a later patch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/argv.h |  1 +
 lib/argv.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/lib/argv.h b/lib/argv.h
index 2104dd42748d..efc390ae4fae 100644
--- a/lib/argv.h
+++ b/lib/argv.h
@@ -8,3 +8,4 @@
 extern void __setup_args(void);
 extern void setup_args_progname(const char *args);
 extern void setup_env(char *env, int size);
+extern int argv_find(const char *needle, int argc, char **argv);
diff --git a/lib/argv.c b/lib/argv.c
index f0e183a8f02f..6e4593997e0b 100644
--- a/lib/argv.c
+++ b/lib/argv.c
@@ -144,3 +144,14 @@ void setup_env(char *env, int size)
 		*env++ = '\0';
 	}
 }
+
+int argv_find(const char *needle, int argc, char **argv)
+{
+	int i;
+
+	for (i = 0; i < argc; i++)
+		if (strcmp(argv[i], needle) == 0)
+			return i;
+
+	return -1;
+}
-- 
2.17.0
