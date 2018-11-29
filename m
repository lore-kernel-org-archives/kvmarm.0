From: no-reply@patchew.org
Subject: Re: [Qemu-devel] [RFC QEMU v2 0/2] arm/virt: Account for guest pause
 time
Date: Thu, 29 Nov 2018 06:40:53 -0800 (PST)
Message-ID: <154350245267.24722.16191258784592311202@c26723477dc9>
References: <1543352837-21529-1-git-send-email-bijan.mottahedeh@oracle.com>
Reply-To: qemu-devel@nongnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E07C4A330
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Nov 2018 09:41:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S1Sy41Pmlqdm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Nov 2018 09:41:13 -0500 (EST)
Received: from sender-of-o52.zoho.com (sender-of-o52.zoho.com [135.84.80.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65F6B4A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Nov 2018 09:41:13 -0500 (EST)
In-Reply-To: <1543352837-21529-1-git-send-email-bijan.mottahedeh@oracle.com>
Resent-Message-Id: <20181129144120.2E07C4A330@mm01.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: bijan.mottahedeh@oracle.com
Cc: famz@redhat.com, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Subject: [Qemu-devel] [RFC QEMU v2 0/2] arm/virt: Account for guest pause time
Message-id: 1543352837-21529-1-git-send-email-bijan.mottahedeh@oracle.com

=== TEST SCRIPT BEGIN ===
#!/bin/bash

BASE=base
n=1
total=$(git log --oneline $BASE.. | wc -l)
failed=0

git config --local diff.renamelimit 0
git config --local diff.renames True
git config --local diff.algorithm histogram

commits="$(git log --format=%H --reverse $BASE..)"
for c in $commits; do
    echo "Checking PATCH $n/$total: $(git log -n 1 --format=%s $c)..."
    if ! git show $c --format=email | ./scripts/checkpatch.pl --mailback -; then
        failed=1
        echo
    fi
    n=$((n+1))
done

exit $failed
=== TEST SCRIPT END ===

Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
Switched to a new branch 'test'
bf7b6dc arm/virt: Account for guest pause time
21423f4 arm/virt: Initialize generic timer scale factor dynamically

=== OUTPUT BEGIN ===
Checking PATCH 1/2: arm/virt: Initialize generic timer scale factor dynamically...
ERROR: exactly one space required after that #ifdef
#33: FILE: hw/arm/virt.c:1757:
+#ifdef  CONFIG_KVM

total: 1 errors, 0 warnings, 106 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Checking PATCH 2/2: arm/virt: Account for guest pause time...
=== OUTPUT END ===

Test command exited with code: 1


---
Email generated automatically by Patchew [http://patchew.org/].
Please send your feedback to patchew-devel@redhat.com
