Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A971266B72
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757456044; cv=none; b=p8Fz7lFgVlRSC0LL1Wh5ueNmbN64Tne+jD+NshaXD01PmHfHQQE7zuvWsZldugExoMV+UHjG78mlTYMxW9yxsbSpQ+AWTLCJfKtBHQ59RnTsTMPgk03pNvARMqUrCVYrPwqDsLnRLfFLbPGR1Iz36+vCgGT3+Z+QhSX3fpVaa7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757456044; c=relaxed/simple;
	bh=PYIAsj4RvlpWJFOrmnHR9CoRf0kWHBFzR92EDPrdD24=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NhhO5c9mSvLkKjscUg/qdnvPnp/j5E+GgXbDzwrjumPer86e+bLfHLn/2qhzucNnOvD1X60KlJZiKoUP6r79KwtaarwDb5rwF2D1YQ1pibE4dFaqlk3rxP7cznmpmWpapKRVcvgGUkQvkLfnqLE8NTXKLq6YOijKe18lH7wUEaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-402abd9bfadso42100165ab.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 15:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757456042; x=1758060842;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zw59uJYB8zcIh7FLbcIyTw0ioHftmj/xE73G6yh2vKQ=;
        b=ujy65RvQI60Gw6zsiciWd8c2ApHY/WcwGiy3D6iaHyistej7Wh3HxAqjpI2r/vCMxe
         hM2p1YjWEZXiddjwoe5EhxZRxmrFIbSURpX5riU5KHw6OSEbLzWpW+XWG5Fh8iGQNcbC
         lHKhbnkj7nMYCVSBqz1Y/vsVDBs2IfwbkZTRyjXjdJSYQTbphcpbVZfWKGLSbUNkGj+P
         Dg8mRk+5BBDUUsmudqMxhcm/d4pjDRMDDcUGh7IT0ftnT/+at+IdMcMQX7AnEg9Hmn9p
         GpRQpuK0tU2J2zYEqLQfa4UAeGLy2RJK/OxR7uAdLBbLgSf4qGsWTsVCuvsQxkoy62Qn
         iwdw==
X-Forwarded-Encrypted: i=1; AJvYcCWgkl5zHoteu7od9dLhl0ZfcxCmB5O2cw6ETrqFMWNL/ou422zqPX+tHTTT1LtQVzHa7DtayBs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3bRej/dQvkDlEkEqCjxAfcLe3Uy6MHqKgohm4dCRgR/SjHFHN
	AunR/TvGte7FsDSDVdFfsPzrzoFe3FqlNUdZVkEXHvxX4VGoZMPTh2RwTb9hTV1Y7FNdMUAyOYy
	tnB0KUR/gR1AIHselwcGCnT6U0DgYXnW6uKupai79+TStpMLMmiowYqhkrUc=
X-Google-Smtp-Source: AGHT+IGHvOeKJug813Vob6cZJ9nEcHyAD5wgbUBvqxQDl2XEVxLYmsv6P43dyQnBUA7nkY8/30bLWX69YQNA8++fSHtmYBVm0EO2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1542:b0:40e:9e8c:b48c with SMTP id
 e9e14a558f8ab-40e9e8cb5a2mr77954395ab.15.1757456042195; Tue, 09 Sep 2025
 15:14:02 -0700 (PDT)
Date: Tue, 09 Sep 2025 15:14:02 -0700
In-Reply-To: <aMCaviNcIeaB9SLV@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c0a6aa.050a0220.3c6139.0010.GAE@google.com>
Subject: Re: [syzbot] [kvmarm?] [kvm?] WARNING: locking bug in vgic_put_irq
From: syzbot <syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to copy binary to VM: failed to run ["scp" "-P" "31225" "-F" "/dev/n=
ull" "-o" "UserKnownHostsFile=3D/dev/null" "-o" "IdentitiesOnly=3Dyes" "-o"=
 "BatchMode=3Dyes" "-o" "StrictHostKeyChecking=3Dno" "-o" "ConnectTimeout=
=3D10" "/tmp/syz-executor3241787550" "root@localhost:/syz-executor324178755=
0"]: exit status 255
Connection timed out during banner exchange
Connection to 127.0.0.1 port 31225 timed out
scp: Connection closed




syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOARCH=3D'arm64'
GOARM64=3D'v8.0'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -pthread -Wl,--no-gc-sections -fmessage-length=3D0 -ffi=
le-prefix-map=3D/tmp/go-build3554905218=3D/tmp/go-build -gno-record-gcc-swi=
tches'
GOHOSTARCH=3D'arm64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mo=
d'
GOMODCACHE=3D'/syzkaller/jobs/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_arm64'
GOVCS=3D''
GOVERSION=3D'go1.24.4'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at bf27483f96
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go: downloading golang.org/x/sys v0.34.0
go: downloading github.com/prometheus/client_golang v1.23.0
go: downloading github.com/prometheus/common v0.65.0
go: downloading github.com/prometheus/client_model v0.6.2
go: downloading github.com/prometheus/procfs v0.16.1
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3Dbf27483f963359281b2d9b6d6efd36289f82e282 -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20250821-140520"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3Dbf27483f963359281b2d9b6d6efd36289f82e282 -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20250821-140520"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Darm64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3Dbf27483f963359281b2d9b6d6efd36289f82e282 -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20250821-140520"  -o ./bi=
n/linux_arm64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_arm64
g++ -o ./bin/linux_arm64/syz-executor executor/executor.cc \
	-O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-l=
arger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-format-ove=
rflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -stati=
c-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH_arm6=
4=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"bf27483f963359281b2d9b6d6efd36289f=
82e282\"
go: downloading golang.org/x/sync v0.16.0
go: downloading golang.org/x/exp v0.0.0-20250711185948-6ae5c78190dc
go: downloading cloud.google.com/go/spanner v1.82.0
go: downloading cloud.google.com/go/bigquery v1.69.0
go: downloading github.com/sergi/go-diff v1.4.0
go: downloading google.golang.org/genproto v0.0.0-20250603155806-513f239258=
22
go: downloading google.golang.org/genproto/googleapis/api v0.0.0-2025060315=
5806-513f23925822
go: downloading github.com/GoogleCloudPlatform/opentelemetry-operations-go/=
exporter/metric v0.52.0
go: downloading github.com/GoogleCloudPlatform/opentelemetry-operations-go/=
detectors/gcp v1.28.0
go: downloading github.com/GoogleCloudPlatform/opentelemetry-operations-go/=
internal/resourcemapping v0.52.0
go: downloading github.com/golang/groupcache v0.0.0-20241129210726-2c02b820=
8cf8
go: downloading github.com/go-logr/logr v1.4.3
go: downloading github.com/goccy/go-json v0.10.5
go: downloading golang.org/x/net v0.42.0
go: downloading github.com/cncf/xds/go v0.0.0-20250501225837-2ac532fd4443
go: downloading cel.dev/expr v0.24.0
go: downloading github.com/go-jose/go-jose/v4 v4.1.0
go: downloading golang.org/x/text v0.27.0
go: downloading golang.org/x/crypto v0.40.0
/usr/bin/ld: /tmp/ccHdKQ2T.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0xd8): warning: Using 'gethostbyname' in statically linked applicati=
ons requires at runtime the shared libraries from the glibc version used fo=
r linking



Tested on:

commit:         2d047827 KVM: arm64: vgic: fix incorrect spinlock API ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm=
.git fixes
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da348a32a552b643=
4
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dcef594105ac7e60c6=
d93
compiler:       Debian clang version 20.1.8 (++20250708123704+0de59a293f7a-=
1~exp1~20250708003721.134), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.
