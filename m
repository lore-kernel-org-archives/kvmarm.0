From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 2/2] Documentation: remove documentation stubs and
 common-cmds.h generation
Date: Tue, 23 Feb 2016 17:41:05 +0000
Message-ID: <1456249265-13751-3-git-send-email-andre.przywara@arm.com>
References: <1456249265-13751-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55684412F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 12:34:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJyMoLwHOoxZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2016 12:34:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF468412ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 12:34:30 -0500 (EST)
In-Reply-To: <1456249265-13751-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, kvmarm@lists.cs.columbia.edu, Dimitri John Ledkov <dimitri.j.ledkov@intel.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have a manpage in place, we can remove the manpage-style
text files from the Documentation directory.
This allows us also to get rid of the crude common-cmds.h generation,
which relied on these files and on a command-list.txt file.
Instead include the version of that header file generated with the
current HEAD into the source tree.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .gitignore                    |  1 -
 Documentation/kvm-balloon.txt | 24 -----------------
 Documentation/kvm-debug.txt   | 16 -----------
 Documentation/kvm-list.txt    | 16 -----------
 Documentation/kvm-pause.txt   | 16 -----------
 Documentation/kvm-resume.txt  | 16 -----------
 Documentation/kvm-run.txt     | 62 -------------------------------------------
 Documentation/kvm-sandbox.txt | 16 -----------
 Documentation/kvm-setup.txt   | 15 -----------
 Documentation/kvm-stat.txt    | 19 -------------
 Documentation/kvm-stop.txt    | 16 -----------
 Documentation/kvm-version.txt | 21 ---------------
 Makefile                      | 10 -------
 command-list.txt              | 15 -----------
 include/common-cmds.h         | 19 +++++++++++++
 15 files changed, 19 insertions(+), 263 deletions(-)
 delete mode 100644 Documentation/kvm-balloon.txt
 delete mode 100644 Documentation/kvm-debug.txt
 delete mode 100644 Documentation/kvm-list.txt
 delete mode 100644 Documentation/kvm-pause.txt
 delete mode 100644 Documentation/kvm-resume.txt
 delete mode 100644 Documentation/kvm-run.txt
 delete mode 100644 Documentation/kvm-sandbox.txt
 delete mode 100644 Documentation/kvm-setup.txt
 delete mode 100644 Documentation/kvm-stat.txt
 delete mode 100644 Documentation/kvm-stop.txt
 delete mode 100644 Documentation/kvm-version.txt
 delete mode 100644 command-list.txt
 create mode 100644 include/common-cmds.h

diff --git a/.gitignore b/.gitignore
index a16a97f..f21a0bd 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,7 +6,6 @@
 *.swp
 .cscope
 tags
-include/common-cmds.h
 tests/boot/boot_test.iso
 tests/boot/rootfs/
 guest/init
diff --git a/Documentation/kvm-balloon.txt b/Documentation/kvm-balloon.txt
deleted file mode 100644
index efc0a87..0000000
--- a/Documentation/kvm-balloon.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-lkvm-balloon(1)
-================
-
-NAME
-----
-lkvm-balloon - Inflate or deflate the virtio balloon
-
-SYNOPSIS
---------
-[verse]
-'lkvm balloon [command] [size] [instance]'
-
-DESCRIPTION
------------
-The command inflates or deflates the virtio balloon located in the
-specified instance.
-For a list of running instances see 'lkvm list'.
-
-Command can be either 'inflate' or 'deflate'. Inflate increases the
-size of the balloon, thus decreasing the amount of virtual RAM available
-for the guest. Deflation returns previously inflated memory back to the
-guest.
-
-size is specified in Mb.
diff --git a/Documentation/kvm-debug.txt b/Documentation/kvm-debug.txt
deleted file mode 100644
index a8eb2c0..0000000
--- a/Documentation/kvm-debug.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-lkvm-debug(1)
-================
-
-NAME
-----
-lkvm-debug - Print debug information from a running instance
-
-SYNOPSIS
---------
-[verse]
-'lkvm debug [instance]'
-
-DESCRIPTION
------------
-The command prints debug information from a running instance.
-For a list of running instances see 'lkvm list'.
diff --git a/Documentation/kvm-list.txt b/Documentation/kvm-list.txt
deleted file mode 100644
index a245607..0000000
--- a/Documentation/kvm-list.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-lkvm-list(1)
-================
-
-NAME
-----
-lkvm-list - Print a list of running instances on the host.
-
-SYNOPSIS
---------
-[verse]
-'lkvm list'
-
-DESCRIPTION
------------
-This command prints a list of running instances on the host which
-belong to the user who currently ran 'lkvm list'.
diff --git a/Documentation/kvm-pause.txt b/Documentation/kvm-pause.txt
deleted file mode 100644
index 1ea2a23..0000000
--- a/Documentation/kvm-pause.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-lkvm-pause(1)
-================
-
-NAME
-----
-lkvm-pause - Pause the virtual machine
-
-SYNOPSIS
---------
-[verse]
-'lkvm pause [instance]'
-
-DESCRIPTION
------------
-The command pauses a virtual machine.
-For a list of running instances see 'lkvm list'.
diff --git a/Documentation/kvm-resume.txt b/Documentation/kvm-resume.txt
deleted file mode 100644
index a36c4df..0000000
--- a/Documentation/kvm-resume.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-lkvm-resume(1)
-================
-
-NAME
-----
-lkvm-resume - Resume the virtual machine
-
-SYNOPSIS
---------
-[verse]
-'lkvm resume [instance]'
-
-DESCRIPTION
------------
-The command resumes a virtual machine.
-For a list of running instances see 'lkvm list'.
diff --git a/Documentation/kvm-run.txt b/Documentation/kvm-run.txt
deleted file mode 100644
index 8ddf470..0000000
--- a/Documentation/kvm-run.txt
+++ /dev/null
@@ -1,62 +0,0 @@
-lkvm-run(1)
-================
-
-NAME
-----
-lkvm-run - Start the virtual machine
-
-SYNOPSIS
---------
-[verse]
-'lkvm run' [-k <kernel image> | --kernel <kernel image>]
-
-DESCRIPTION
------------
-The command starts a virtual machine.
-
-OPTIONS
--------
--m::
---mem=::
-	Virtual machine memory size in MiB.
-
--p::
---params::
-	Additional kernel command line arguments.
-
--r::
---initrd=::
-	Initial RAM disk image.
-
--k::
---kernel=::
-	The virtual machine kernel.
-
---dev=::
-	KVM device file.
-
--i::
---image=::
-	A disk image file.
-
--s::
---single-step::
-	Enable single stepping.
-
--g::
---ioport-debug::
-	Enable ioport debugging.
-
--c::
---enable-virtio-console::
-	Enable the virtual IO console.
-
---cpus::
-	The number of virtual CPUs to run.
-
---debug::
-	Enable debug messages.
-
-SEE ALSO
---------
-linkkvm:
diff --git a/Documentation/kvm-sandbox.txt b/Documentation/kvm-sandbox.txt
deleted file mode 100644
index 2d7f558..0000000
--- a/Documentation/kvm-sandbox.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-lkvm-sandbox(1)
-================
-
-NAME
-----
-lkvm-sandbox - Run a command in a sandboxed guest
-
-SYNOPSIS
---------
-[verse]
-'lkvm sandbox ['lkvm run' arguments] -- [sandboxed command]'
-
-DESCRIPTION
------------
-The sandboxed command will run in a guest as part of it's init
-command.
diff --git a/Documentation/kvm-setup.txt b/Documentation/kvm-setup.txt
deleted file mode 100644
index 4b6e331..0000000
--- a/Documentation/kvm-setup.txt
+++ /dev/null
@@ -1,15 +0,0 @@
-lkvm-setup(1)
-================
-
-NAME
-----
-lkvm-setup - Setup a new virtual machine
-
-SYNOPSIS
---------
-[verse]
-'lkvm setup <name>'
-
-DESCRIPTION
------------
-The command setups a virtual machine.
diff --git a/Documentation/kvm-stat.txt b/Documentation/kvm-stat.txt
deleted file mode 100644
index 101ce7a..0000000
--- a/Documentation/kvm-stat.txt
+++ /dev/null
@@ -1,19 +0,0 @@
-lkvm-stat(1)
-================
-
-NAME
-----
-lkvm-stat - Print statistics about a running instance
-
-SYNOPSIS
---------
-[verse]
-'lkvm [command] [-n instance] [-p instance pid] [--all]'
-
-DESCRIPTION
------------
-The command prints statistics about a running instance.
-For a list of running instances see 'lkvm list'.
-
-Commands:
- --memory, -m	Display memory statistics
diff --git a/Documentation/kvm-stop.txt b/Documentation/kvm-stop.txt
deleted file mode 100644
index 6e4bc83..0000000
--- a/Documentation/kvm-stop.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-lkvm-stop(1)
-================
-
-NAME
-----
-lkvm-stop - Stop a running instance
-
-SYNOPSIS
---------
-[verse]
-'lkvm stop [instance]'
-
-DESCRIPTION
------------
-The command stops a running instance.
-For a list of running instances see 'lkvm list'.
diff --git a/Documentation/kvm-version.txt b/Documentation/kvm-version.txt
deleted file mode 100644
index 41003d2..0000000
--- a/Documentation/kvm-version.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-lkvm-version(1)
-================
-
-NAME
-----
-lkvm-version - Print the version of the kernel tree kvm tools
-was built on.
-
-SYNOPSIS
---------
-[verse]
-'lkvm version'
-
-DESCRIPTION
------------
-The command prints the version of the kernel that was used to build
-kvm tools.
-
-Note that the version is not the version of the kernel which is currently
-running on the host, but is the version of the kernel tree from which kvm
-tools was built.
diff --git a/Makefile b/Makefile
index 59622c3..99ebbb2 100644
--- a/Makefile
+++ b/Makefile
@@ -399,9 +399,6 @@ $(GUEST_INIT): guest/init.c
 %.s: %.c
 	$(Q) $(CC) -o $@ -S $(CFLAGS) -fverbose-asm $<
 
-# The header file common-cmds.h is needed for compilation of builtin-help.c.
-builtin-help.static.o builtin-help.o: $(KVM_INCLUDE)/common-cmds.h
-
 $(OBJS):
 
 util/rbtree.static.o util/rbtree.o: util/rbtree.c
@@ -429,12 +426,6 @@ endif
 	$(Q) $(CC) -c $(c_flags) $(CFLAGS_DYNOPT) $< -o $@
 
 
-$(KVM_INCLUDE)/common-cmds.h: util/generate-cmdlist.sh command-list.txt
-
-$(KVM_INCLUDE)/common-cmds.h: $(wildcard Documentation/kvm-*.txt)
-	$(E) "  GEN     " $@
-	$(Q) util/generate-cmdlist.sh > $@+ && mv $@+ $@
-
 #
 # BIOS assembly weirdness
 #
@@ -496,7 +487,6 @@ clean:
 	$(Q) rm -f cscope.*
 	$(Q) rm -f tags
 	$(Q) rm -f TAGS
-	$(Q) rm -f $(KVM_INCLUDE)/common-cmds.h
 	$(Q) rm -f KVMTOOLS-VERSION-FILE
 .PHONY: clean
 
diff --git a/command-list.txt b/command-list.txt
deleted file mode 100644
index d93597d..0000000
--- a/command-list.txt
+++ /dev/null
@@ -1,15 +0,0 @@
-#
-# List of known perf commands.
-# command name			category [deprecated] [common]
-#
-lkvm-run			mainporcelain common
-lkvm-setup			mainporcelain common
-lkvm-pause			common
-lkvm-resume			common
-lkvm-version			common
-lkvm-list			common
-lkvm-debug			common
-lkvm-balloon			common
-lkvm-stop			common
-lkvm-stat			common
-lkvm-sandbox			common
diff --git a/include/common-cmds.h b/include/common-cmds.h
new file mode 100644
index 0000000..5b95676
--- /dev/null
+++ b/include/common-cmds.h
@@ -0,0 +1,19 @@
+struct cmdname_help
+{
+    char name[16];
+    char help[80];
+};
+
+static struct cmdname_help common_cmds[] = {
+  {"run", "Start the virtual machine"},
+  {"setup", "Setup a new virtual machine"},
+  {"pause", "Pause the virtual machine"},
+  {"resume", "Resume the virtual machine"},
+  {"version", "Print the version of the kernel tree kvm tools"},
+  {"list", "Print a list of running instances on the host."},
+  {"debug", "Print debug information from a running instance"},
+  {"balloon", "Inflate or deflate the virtio balloon"},
+  {"stop", "Stop a running instance"},
+  {"stat", "Print statistics about a running instance"},
+  {"sandbox", "Run a command in a sandboxed guest"},
+};
-- 
2.6.4
