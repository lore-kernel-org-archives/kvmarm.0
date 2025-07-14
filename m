Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4021C254855
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752502864; cv=none; b=JKl7NHGg+w+TSquliiVNBP5qhFhaDd8zsWOJsScIql80DltM/qyC0VAcs6U/AIV61BeFlzSQIS3tSjY090g69E0M1h+eUvpM1xb6+kOjyb12eihVNX6OfiVnrtIpBdxzIhMAa7mMxLi7acooVxkUEaQCjZ0/bYq6QR0b5kj9OfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752502864; c=relaxed/simple;
	bh=BVOInpbtk0Qig8X2holu5imSR0FItlopCBIjw1I628o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=eapW1ffLHipPYN8l+iYjH3VFCR6KS+tHKxkZTy+p7TyLtG+yPBf7dUqRWiEGU4/ja9n+HK1HijsIq0Le7jgueqwA8BqSCnNTlhp4HH4xqeWwSurFo83uHp9petBPH1J03AY4C5bHPhcUdNH85pYKr+B5wErlaSyfG/1FxcGtYOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86cf0364dd2so754202139f.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 07:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752502862; x=1753107662;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Qqgiq8JxyEcAgDrZLb+6D8UwLrwRRPLE/xGlnoIsFU=;
        b=wY9N2ECODFUDK3vYDqvQul5PqxE08dKyXTEBGysMfeP34Yf6+DWQVLyi0pgq30h/yD
         YS0DLxOIPcBbASlSn76lOW/0zG2pbQEnsFYHZNoe5P3MKtRM87wMGZSquNktrNOm20x0
         52V/3Zho299Tw70BH567dAxbbCHwSgMvUMttQU5CR/6Ykn7qwEZ3lUkxBNCW382WJdOe
         tCDpxarOAX/hEbAgtDEKVGCLuAy4mAhFHHJgi1aZ0TXgaFMkmbECTkEYgtoMWLWK7mQF
         Ng50Rh8KNUhEF9nwxs5t7G0eGrpSsyZri+ipTvz9YwD5xv0f7RUfpbZLvtUX7ydrsgZy
         wAHA==
X-Forwarded-Encrypted: i=1; AJvYcCV+ZEo/qtPdVfz4lpY6jFDo1srsTW08LH8ReLSpQ5LVeyS3ejJz8gYB9xnksaQpz24VI4+UjEw=@lists.linux.dev
X-Gm-Message-State: AOJu0YziJrYR4dcmrDNdn68eicnI6peOkhFFychBybA5tITs6xHmGS0N
	y8wpjcn6xp5TnKhm+LoNQAenliN7+HlFrPc6Ez7Q2GqWLlv4VtNd+meDu724pHjxJCZF3ocLhVM
	q4UhLhfrJ6VqOYSBz2Q0MNO5Ye4512e/R9caEgWDmWi6607s7+xamLlM9jS4=
X-Google-Smtp-Source: AGHT+IGSjX8dQuyeF+nrdRxt2lvfKv070vfD+xMFqoSuPZlV/8eE5ffgfNQmsMmBill3U8kjHbWGi/Yiq1YgCqNWyw/IWLC2bkZV
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6808:b0:875:d589:5b0b with SMTP id
 ca18e2360f4ac-8797aa2f686mr1289387039f.11.1752502862398; Mon, 14 Jul 2025
 07:21:02 -0700 (PDT)
Date: Mon, 14 Jul 2025 07:21:02 -0700
In-Reply-To: <861pqiaojt.wl-maz@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6875124e.a70a0220.2b0948.0001.GAE@google.com>
Subject: Re: [syzbot] [kvmarm?] WARNING in pend_sync_exception
From: syzbot <syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com
Tested-by: syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com

Tested on:

commit:         e62014ac KVM: arm64: Clear pending exception state bef..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/df-2-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=17d1918c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4b46866d7105151
dashboard link: https://syzkaller.appspot.com/bug?extid=4e09b1432de3774b86ae
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
