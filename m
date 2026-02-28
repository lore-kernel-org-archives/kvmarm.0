Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3129D279355
	for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772294224; cv=none; b=MB0KsckbbVA787XJP/3BoSFbglVkrQ627zZG1xf+27BgLVpF/XZ5UPW3RSd/wW9sozEaYbBgsCFWXhHe770Y2rJj+V3W3BP1LK3nTB5wLcXE5hA2Layovtvj5nxRF1gDh7i7WSs/P4rVqSyvJLS7wRD4uS4Zc9F+rQMrK9cWB8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772294224; c=relaxed/simple;
	bh=VU9ClshQ4AjoYILXK+ofmUahe+cXnPSNQCKVmqUzIw4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=fkswR8LhOt4sXyBbwxJYFHxccBoSx9LB1KQgTM6rioFteoJ+hIZHKy67Tj1hDor30KOzaZEJ68PFTh2GmCThfLuF2NYBewqsrNwIynWrN3Yj51Ye9PPPTOQ200dRHtb8i3C0n+5t1J266DkHXUNQcFS1EWGiajnnEphicU0I054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-679dcf1f680so83246276eaf.0
        for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 07:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772294222; x=1772899022;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=smD2HaiHLIOJ/xJDEhd0WTnFcnRAIKeje4UXvrICVpU=;
        b=cIGL5W3rcS6ACx1dnmjYyO5QR3JDtePEaTMuAbuwt/BC+JXk2JNFFZGysTxf/OsLiC
         Clj1nHjlS4eZCEtpZpjz0Mr5/Z8gqOXsuQeT6maC/Ij6OHpseeM+QFA3K3JilfgMoHJS
         6CCmg+RPI6UlySQIQdhKWHKmo1zVGlZnnoGE+mV+MpQQJvvVxz0PuERJPJjhLEwuhVp7
         dQVu5Gbh1MS3yq4v6DEVWDT98YIO30843SfM6BMr5m9x4QoJ6KHCPTSTae14jDas8z/N
         Yypl0GAUKRUKAn7rqwM1hKu3CUwvTqrdq7YTiXzePu9w+3fQ8FohOpuXrK5+nUVapjTm
         IxAg==
X-Forwarded-Encrypted: i=1; AJvYcCX0qWBWtBmeUUo/U7yROacuhqd8JkAum6NDwEuGKkenKPPWBPOd6KuCpzEX+K/TJe/xEmQzuyM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/h7eVMQs3Ta9ioA25rTmpYHp9mXcYpk4IRW8e83ZjI3VxYIeR
	2LcgA2zR6/ug9lgcQ+P1Sgaug/go3aiYnGCSnAz0t/wtRQMLW7Qmmmgngxy/YArcgzo+y2wzshu
	ch/YheYFdZnFL2msUuzUHdtAIJre9Ehe05q/qL+RvH6/FSz9bU2px9z3vFwM=
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:228a:b0:66e:7aaa:be76 with SMTP id
 006d021491bc7-679faf0f951mr3959548eaf.43.1772294222196; Sat, 28 Feb 2026
 07:57:02 -0800 (PST)
Date: Sat, 28 Feb 2026 07:57:02 -0800
In-Reply-To: <874in0ex49.wl-maz@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a3104e.050a0220.3a55be.0041.GAE@google.com>
Subject: Re: [syzbot] [kvmarm?] [kvm?] BUG: unable to handle kernel paging
 request in kvm_vgic_destroy
From: syzbot <syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, 
	syzkaller@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com
Tested-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com

Tested on:

commit:         949862c2 KVM: arm64: Eagerly init vgic dist/redist on ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vgic-fixes-7.0
console output: https://syzkaller.appspot.com/x/log.txt?x=15f88952580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31d0db0315ae5d07
dashboard link: https://syzkaller.appspot.com/bug?extid=f6a46b038fc243ac0175
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
